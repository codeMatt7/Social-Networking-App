//
//  User.swift
//  FirebaseLive
//
//  Created by Matthew Houston on 1/15/17.
//  Copyright © 2017 Matthew Houston. All rights reserved.
//


import Foundation
import Firebase

struct User {

    var email: String!
    var firstName: String
    var lastName: String
    var uid: String!
    var profilePictureUrl: String
    var country: String
    var ref: FIRDatabaseReference!
    var key: String = ""
    var isVerified: Bool = false
    
    init(snapshot: FIRDataSnapshot) {
        self.email = (snapshot.value as! NSDictionary) ["email"] as! String
        self.firstName = (snapshot.value as! NSDictionary) ["firstname"] as! String
        self.lastName = (snapshot.value as! NSDictionary) ["lastname"] as! String
        self.uid = (snapshot.value as! NSDictionary) ["uid"] as! String
        self.country = (snapshot.value as! NSDictionary) ["country"] as! String
        self.profilePictureUrl = (snapshot.value as! NSDictionary) ["profilePictureUrl"] as! String
        self.ref = snapshot.ref
        self.isVerified = (snapshot.value as! NSDictionary)["isVerified"] as! Bool
    }
    
    init(email: String, firstName: String, lastName: String,  uid: String, profilePictureUrl: String, country: String) {
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.profilePictureUrl = profilePictureUrl
        self.country = country
        self.ref = FIRDatabase.database().reference()
        //self.isVerified = false
        
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func toAnyObject() -> [String: Any] {
        return ["email": email, "firstname": firstName, "lastname": lastName, "country":country, "uid":uid, "profilePictureUrl":profilePictureUrl, "isVerified":self.isVerified]
    }
    

}
