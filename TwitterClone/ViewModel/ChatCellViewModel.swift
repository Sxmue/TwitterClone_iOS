//
//  ChatCellViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 15/5/24.
//

import UIKit


struct ChatCellViewModel {
    
    
    let chat: Chat
    
    
    var profileImage: URL {
        guard let url = chat.user.profileImageURL else {return URL(fileURLWithPath: "") }
        return url
    }
    
    var usernmeText: String {
        return chat.user.username
    }
    
    var contentText: String {
        return chat.message.content
    }
    
    var timestampText:String {
        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        // Esto es nuevo, y de esta manera le podemos dar formato
        formatter.dateFormat = "HH:mm"

        return formatter.string(from: chat.message.timestamp)
    }
    
    
    
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    
    
}
