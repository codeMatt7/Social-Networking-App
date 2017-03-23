//
//  UserProfileViewController.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit
import Firebase

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userProfileImageView: CustomizableImageView!
    
    @IBOutlet weak var firstnameTextfield: CustomizableTextfield!
    
    @IBOutlet weak var lastnameTextfield: CustomizableTextfield!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    var networkService = NetworkingService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchCurrentUserInfo()
    }
    
    
    private func fetchCurrentUserInfo() {
        networkService.fetchCurrentUserInfo { (user) in
            if let user = user {
                self.countryLabel.text = user.country
                self.emailLabel.text = user.email
                self.firstnameTextfield.text = user.firstName
                self.lastnameTextfield.text = user.lastName
                self.networkService.downloadImageFromFirebase(urlString: user.profilePictureUrl, completion: { (image) in
                    if let image = image {
                        DispatchQueue.main.async(execute: { 
                            self.userProfileImageView.image = image
                        })
                    }
                })
            }
        }
    }

}
