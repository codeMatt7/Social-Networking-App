//
//  ViewController.swift
//  Swiftify
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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

    @IBOutlet weak var forgotDetailButton: UIButton!
    @IBOutlet weak var signInButton: CustomizableButton!
    
    var networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setTapGestureRecognizerOnView()
        setSwipeGestureRecognizerOnView()
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBAction func signInAction(_ sender: CustomizableButton) {
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!
        
        if finalEmail.isEmpty || password.isEmpty {
            let alert = SCLAlertView()
            _ = alert.showWarning("OH LA LA NO 🙈!", subTitle: "One or more fields have not been filled. Please try again.")
        }else {
            if isValidEmail(email: finalEmail) {
                self.networkingService.signInUser(email: finalEmail, password:password)
            }
        }
        
        self.view.endEditing(true) //dismiss keyboard
        
    }
  
    
   
    

}

extension LoginViewController {
    
    @IBAction func unwindToLogin(_ storyboardSegue: UIStoryboardSegue){} //unwinding to home view controller when pressed
    
    private func hideForgotDetailButton(isHidden: Bool){
        self.forgotDetailButton.isHidden = isHidden
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        hideForgotDetailButton(isHidden: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            80)
        hideForgotDetailButton(isHidden: false)
    }
    
    // Move the View Up & Down when the Keyboard appears
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboardOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    func setSwipeGestureRecognizerOnView(){
    let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboardOnTap))
    swipDown.direction = .down
    self.view.addGestureRecognizer(swipDown)
    }
}
