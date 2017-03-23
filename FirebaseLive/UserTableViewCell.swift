//
//  UserTableViewCell.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var verifiedUserImageView: UIImageView!
    
    func configureCellForUser(user: User) {
        self.countryLabel.text = user.country
        self.username.text = user.getFullName()
        downloadImageFromFirebase(urlString: user.profilePictureUrl)
        
    self.verifiedUserImageView.isHidden = !user.isVerified //add optional mark
    }
    
    func downloadImageFromFirebase(urlString: String) {
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in  //fetch images where size doesnt exceed 1024 mb
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let data = imageData {
                    DispatchQueue.main.async(execute: {
                        self.userImageView.image = UIImage(data: data)
                    })
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
