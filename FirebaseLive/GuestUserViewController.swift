//
//  GuestUserViewController.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit
import Firebase

class GuestUserViewController: UIViewController {

    
    @IBOutlet weak var firstnameLabel: CustomizableTextfield!
    @IBOutlet weak var lastnameLabel: CustomizableTextfield!
    @IBOutlet weak var guestImageView: CustomizableImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var ref: FIRDatabaseReference?
    
    let networkingService = NetworkingService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.fetchGuestUserInfo()
    }
    
    private func setGuestUserInfo() {
        networkingService.fetchGuestUserInfo(ref: ref) { (user) in
        }
    }
    
    private func fetchGuestUserInfo() {
        networkingService.fetchGuestUserInfo(ref: ref, completion: { (user) in
            if let user = user {
                self.countryLabel.text = user.country
                self.emailLabel.text = user.email
                self.firstnameLabel.text = user.firstName
                self.lastnameLabel.text = user.lastName
                self.networkingService.downloadImageFromFirebase(urlString: user.profilePictureUrl, completion: { (image) in
                    if let image = image {
                        DispatchQueue.main.async(execute: {
                            self.guestImageView.image = image
                        })
                    }
                })
            }
        })
    }
}
