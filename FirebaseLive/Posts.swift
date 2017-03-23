//
//  Posts.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import Foundation
import Firebase

struct Post {
    
    enum PostType: String {
        case Image, Text
    }
    
    var postId: String!
    var userId: String!
    var postText: String
    var postImageUrl: String
    var date: NSNumber
    var ref: FIRDatabaseReference!
    var key: String = ""
    var type: String
    
    
    init(postId: String!, userId: String!, postText:String, postImageUrl: String?, date: NSNumber, key:String = "", type: PostType) {
        self.postId = postId
        self.userId = userId
        self.postText = postText
        self.postImageUrl = postImageUrl!
        self.date = date
        self.ref = FIRDatabase.database().reference()
        self.type = type.rawValue //string
    }
    
    init(snapshot: FIRDataSnapshot!) {
        self.postId = (snapshot.value as! NSDictionary)["postId"] as! String
        self.userId = (snapshot.value as! NSDictionary)["userId"] as! String
        self.postText = (snapshot.value as! NSDictionary)["postText"] as! String
        self.postImageUrl = (snapshot.value as! NSDictionary)["postImageUrl"] as! String
        self.date = (snapshot.value as! NSDictionary)["postDate"] as! NSNumber
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.type = (snapshot.value as! NSDictionary)["type"] as! String
    }
    
    func toAnyObject() -> [String:Any] {
        return ["postId": self.postId, "userId": self.userId, "postText": self.postText, "postImageUrl": self.postImageUrl, "postDate": self.date, "type": self.type]
    }
}
