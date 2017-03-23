//
//  AddPostViewController.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit
import Firebase

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var postSwitch: UISwitch!
    @IBOutlet weak var postImageView: CustomizableImageView! {
        didSet {
            self.postImageView.alpha = 0
        }
    }
    @IBOutlet weak var postTextView: UITextView!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.postImageView.isUserInteractionEnabled = true //for tap gesture to work
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postPressed(_ sender: CustomizableButton) {
        self.view.endEditing(true) //dismiss keyboard
        
        if postSwitch.isOn {
            
            var postText = ""
            
            if let text = self.postTextView.text {
             postText = text
            }
            
            let postId = NSUUID().uuidString
            let postDate = NSDate().timeIntervalSince1970 as NSNumber
            
            if let image = self.postImageView.image {
                if let imageData = UIImageJPEGRepresentation(image, 0.4) {

                
                networkingService.uploadImageToFirebase(postId: postId, imageData: imageData, completion: { (url) in
                    let post = Post(postId: postId, userId: FIRAuth.auth()?.currentUser!.uid, postText: postText, postImageUrl: String(describing:url), date: postDate, type: Post.PostType.Image)
                    
                    self.networkingService.savePostToDb(post: post, completion: { 
                        
                    })
                    
                    self.dismiss(animated: true, completion: nil)

                })
            }
        }
            
        } else {
            
            var postText = ""
            
            if let text = self.postTextView.text {
                postText = text
            }
            
            let postId = NSUUID().uuidString
            let postDate = NSDate().timeIntervalSince1970 as NSNumber

           let post = Post(postId: postId, userId: FIRAuth.auth()?.currentUser!.uid, postText: postText, postImageUrl: "", date: postDate, type: Post.PostType.Text)
            
            self.networkingService.savePostToDb(post: post, completion: {
                
            })

            self.dismiss(animated: true, completion: nil)
        }
        
        self.view.endEditing(true) //dismiss keyboard
        
    }
    
    @IBAction func choosePostPicture(_ sender: UITapGestureRecognizer) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a picture", message: "sdjdj", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let photosLibraryAction = UIAlertAction(title: "Photos Library Album", style: .default) { (action) in
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
        
        self.present(alertController, animated: true, completion: nil)
    }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.postImageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postSwitchAction(_ sender: Any) {
        if postSwitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.postImageView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0, animations: {
                self.postImageView.alpha = 1.0
            })
        }
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
