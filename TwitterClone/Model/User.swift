//
//  User.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/4/24.
//

import UIKit

struct User {
    let fullname: String
    let username: String
    let email: String
    let profileImage: String
    let uid: String
    
    init (uid: String,dictionary: [String: Any]){
        
        self.uid = uid//Esto hay que hacerlo asi manualmente
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        
        self.email = dictionary["email"] as? String ?? ""
        
        self.username = dictionary["username"] as? String ?? ""
        
        self.profileImage = dictionary["profileImage"] as? String ?? ""

    }
}
