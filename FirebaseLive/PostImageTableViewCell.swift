//
//  PostImageTableViewCell.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import UIKit

class PostImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    
    var networkingService = NetworkingService()
    
    func configureCell(post:Post, users: [User]) {
        
        networkingService.downloadImageFromFirebase(urlString: post.postImageUrl) { (image) in
            if let image = image {
                self.postImageView.image = image
            }
        
        self.postTextLabel.text = post.postText
        
        //date of post
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(post.date))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        
        if differenceOfDate.second! <= 0 {
            self.dateLabel.text = "now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute! == 0 {
            self.dateLabel.text = "\(differenceOfDate.second!)secs."
        } else if differenceOfDate.minute! > 0 && differenceOfDate.hour == 0 {
            self.dateLabel.text = "\(differenceOfDate.minute!)mins."
        } else if differenceOfDate.minute! > 0 && differenceOfDate.day! == 0 {
            self.dateLabel.text = "\(differenceOfDate.hour!)hrs."
        } else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            self.dateLabel.text = "\(differenceOfDate.day!)days"
        } else if differenceOfDate.weekOfMonth! > 0 {
            self.dateLabel.text = "\(differenceOfDate.weekOfMonth)wks."
        }
        
        for user in users {
            if user.uid == post.userId {
                self.usernameLabel.text = user.getFullName()
                self.verifiedImageView.isHidden = !user.isVerified
                
                self.networkingService.downloadImageFromFirebase(urlString: user.profilePictureUrl) { (image) in
                    if let image = image {
                        self.userImageView.image = image
                    }
                }
                
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
