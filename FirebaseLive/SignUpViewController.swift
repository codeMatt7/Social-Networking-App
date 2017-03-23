//
//  SignUpViewController.swift
//  Swiftify
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var emailTextField: CustomizableTextfield! {
        didSet{
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: CustomizableTextfield!{
        didSet{
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var reenterPasswordTextField: CustomizableTextfield! {
        didSet{
            reenterPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var firstnameTextField: CustomizableTextfield!{
        didSet{
            firstnameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var lastnameTextField: CustomizableTextfield! {
        didSet{
            lastnameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var countryTextField: CustomizableTextfield!{
        didSet{
            countryTextField.delegate = self
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBOutlet weak var createAccountButton: CustomizableButton!
    
    @IBOutlet weak var userProfileImageView: CustomizableImageView!
    
    
    var countryArrays: [String] = []
    var pickerView: UIPickerView!
    
    var networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTapGestureRecognizerOnView()
        setSwipeGestureRecognizerOnView()
        getCountries()
        setCountryPickerView()
    }

    @IBAction func createAccountAction(_ sender: CustomizableButton) {
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!
        let reenterPassword = reenterPasswordTextField.text!
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let country = countryTextField.text!
        
        let data = UIImageJPEGRepresentation(userProfileImageView.image!, 0.2)!
        
        if finalEmail.isEmpty || password.isEmpty || reenterPassword.isEmpty || firstname.isEmpty || lastname.isEmpty || country.isEmpty {
            let alert = SCLAlertView()
            _ = alert.showWarning("OH LA LA NO 🙈!", subTitle: "One or more fields have not been filled. Please try again.")
        }else {
            
            if password == reenterPassword {
                
                if isValidEmail(email: finalEmail) {
                    self.networkingService.signUp(firstName: firstname, lastName: lastname, country: country, email: finalEmail, pictureData: data , password: password)
                }
                
            } else {
                let alert = SCLAlertView()
                _ = alert.showError("OOPS🙊", subTitle: "Passwords do not match. Please try again.")
            }

        }
        
        self.view.endEditing(true) //dismiss keyboard
    }
}

extension SignUpViewController {
    
    func getCountries(){
        
        for code in NSLocale.isoCountryCodes as [String]{
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_EN").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            
            countryArrays.append(name)
            countryArrays.sort(by: { (name1, name2) -> Bool in
                name1 < name2
            })
        }
    }
    
    func setCountryPickerView(){
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(colorWithHexValue: 0xB41443)
        countryTextField.inputView = pickerView
    }
    
    
    @IBAction func choosePictureAction(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.modalPresentationStyle = .popover
        pickerController.popoverPresentationController?.delegate = self
        pickerController.popoverPresentationController?.sourceView = userProfileImageView
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userProfileImageView.image = chosenImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
        lastnameTextField.resignFirstResponder()
        reenterPasswordTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 30)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            30)
    }
    
    
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    
    }
    
    @objc private func hideKeyboardOnTap(){
        self.view.endEditing(true)
        
    }
    
    func setTapGestureRecognizerOnView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboardOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func setSwipeGestureRecognizerOnView(){
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboardOnTap))
        swipDown.direction = .down
        self.view.addGestureRecognizer(swipDown)
    }
    
    // MARK: - Picker view data source
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArrays[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countryArrays[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArrays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArrays[row], attributes: [NSForegroundColorAttributeName: UIColor.white])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        label.text = countryArrays[row]
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        return label
    }

}





