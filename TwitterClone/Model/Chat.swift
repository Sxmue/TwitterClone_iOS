//
//  Chat.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 14/5/24.
//

import UIKit

struct Chat {
    
    let uid: String
    
    
    var user: User
    
    var message: Message
    
    
    init(uid: String, user: User, message: Message) {
        self.uid = uid
        self.user = user
        self.message = message
    }
}
