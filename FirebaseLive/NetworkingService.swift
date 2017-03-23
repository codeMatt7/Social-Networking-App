//
//  NetworkingService.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase

struct NetworkingService {
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    func signUp(firstName: String!, lastName: String, country: String!, email: String!, pictureData: Data, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.setUserInfoToDB(user: user, firstName: firstName, lastName: lastName, country: country, pictureData: pictureData, password: password)
            
            //we have a user
            
        })
    }
    
    private func setUserInfoToDB(user: FIRUser! ,firstName: String!, lastName: String, country: String!, pictureData: Data, password: String) {
    
        let profilePicturePath = "profileImage\(user.uid)image.jpg"
        let profilePictureRef = storageRef.child(profilePicturePath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        profilePictureRef.put(pictureData, metadata: metaData) { (newMetaData, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = "\(firstName) \(lastName)"
            
            if let url = newMetaData?.downloadURL() {
                 changeRequest.photoURL = url
            }
            
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)

                }
                
                //no error save user info to db
                self.saveUserInfoToDb(user: user, firstName: firstName, lastName: lastName, country: country, password: password)
                
            })
        }
    }
    
    private func saveUserInfoToDb(user: FIRUser! ,firstName: String!, lastName: String, country: String!, password: String) {
        
        let userRef = databaseRef.child("users").child(user.uid)
        let newUser = User(email: user.email!, firstName: firstName, lastName: lastName, uid: user.uid, profilePictureUrl: String(describing: user.photoURL!), country: country)
        
        userRef.setValue(newUser.toAnyObject()) { (error, ref) in
            if error == nil {
                print("\(firstName) \(lastName) has been signed up successfully")
                
                self.signInUser(email: user.email!, password: password)
                
            } else {
                print(error!.localizedDescription)
            }
            
        }
        
    }
    
    func signInUser(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            //no error sign in successful
            let appDel = UIApplication.shared.delegate as? AppDelegate
            appDel?.takeToHome()
            
            print("\(user!.displayName!) has logged in successfully")
      })
    }
    
    func fetchAllUsers(completion: @escaping([User])-> Void) {
        
        let usersRef = databaseRef.child("users")
        usersRef.observe(.value, with: { (users) in
            
            var resultArray = [User]()
            
            for user in users.children {
                let user = User(snapshot: user as! FIRDataSnapshot)
                let currentUser = FIRAuth.auth()!.currentUser!
                
                if user.uid != currentUser.uid {
                    resultArray.append(user)
                }
                
                completion(resultArray)
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchCurrentUserInfo(completion: @escaping(User?) ->Void) {
        
        let currentUser = FIRAuth.auth()!.currentUser!
        
        let currentUserRef = databaseRef.child("users").child(currentUser.uid)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: User = User(snapshot: currentUser)
                completion(user)
          
           
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchGuestUserInfo(ref:FIRDatabaseReference!, completion: @escaping(User?) ->Void) {
        
        ref.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: User = User(snapshot: currentUser)
            completion(user)
            
            
        }) { (error) in
            print(error.localizedDescription)
        } 
        
    }
    
    func downloadImageFromFirebase(urlString: String, completion: @escaping (UIImage?)-> Void) {
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in  //fetch images where size doesnt exceed 1mb
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let data = imageData {

                    completion(UIImage(data: data))
                }
            }
        }
    }
    
    func uploadImageToFirebase(postId: String, imageData: Data, completion: @escaping (URL)-> Void) {
        
       let postImagePath = "postImages/\(postId)image.jpg"
        let postImageRef = storageRef.child(postImagePath)
        let postImageMetaData = FIRStorageMetadata()
        postImageMetaData.contentType = "image/jpeg"
        postImageRef.put(imageData, metadata: postImageMetaData) { (newPostImage, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
            
                if let postImageURL = newPostImage?.downloadURL() {
                    completion(postImageURL)
                }
            
            }
        }
    }
    
    func savePostToDb(post: Post, completion: ()->Void) {
        
        let postRef = databaseRef.child("posts").childByAutoId()
        postRef.setValue(post.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                //success
                let alertiew = SCLAlertView()
                _ = alertiew.showSuccess("Success", subTitle: "Post saved successfully", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x305894), colorTextButton: UIColor.white)
            }
        }
    }
    
    func fetchPosts(completion: @escaping ([Post])->Void) {
        
        let postRef = databaseRef.child("posts")
        postRef.observe(.value, with: { (posts) in
            
            var resultsArray = [Post]()
            for thePost in posts.children {
                let post = Post(snapshot: thePost as! FIRDataSnapshot)
                resultsArray.append(post)
            }
            
            completion(resultsArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func logOut(completion: ()->()) {
        
        
        if FIRAuth.auth()!.currentUser != nil {
            
            do {
                try FIRAuth.auth()!.signOut()
                
            } catch let error as Error {
                print("failed to log out user: \(error.localizedDescription)")
            }
        }
        
        
    }
    
}










