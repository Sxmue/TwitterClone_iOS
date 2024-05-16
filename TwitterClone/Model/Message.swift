//
//  Message.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit


struct Message {
    
    let messageId: String
    
    var content: String
    
    var timestamp: Date!
    
    var fromUser: String
    
    var toUser: String
    
    var isSended: Bool = false
    
    
    
    
    init(messageId: String,dictionary: [String: Any]){
        
        self.messageId = messageId
        
        self.content = dictionary["content"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        self.fromUser = dictionary["fromUser"] as? String ?? ""
        
        self.toUser = dictionary["toUser"] as? String ?? ""
    }
    
    
}
