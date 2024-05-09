//
//  MessageService.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit
import Firebase



struct MessageService{
    
    static let shared = MessageService()
    
    func fetchMessages(withUser destinationUid:String,completion: @escaping([Message]) -> Void ){
        
        var messages = [Message]()
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        DB_USER_MESSAGES.child(uid).child(destinationUid).observe(.childAdded) { snapshot in
            
            let messageUid = snapshot.key
            
            DB_MESSAGES.child(messageUid).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else {return }
                
                let message = Message(messageId: messageUid, dictionary: dictionary)
                
                messages.append(message)
                completion(messages)
            }
            
        }
        
    }
    
    
    func saveMessage(content: String ,toUser destinationUid: String,completion: @escaping(Error?, DatabaseReference) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        let values = ["timestamp": Int(NSDate().timeIntervalSince1970),
                      "content": content,
                      "fromUser": uid,
                      "toUser": destinationUid] as [String : Any]
        
        DB_MESSAGES.childByAutoId().updateChildValues(values) { error, ref in
            guard let messageID = ref.key else {return }
            
            DB_USER_MESSAGES.child(uid).child(destinationUid).updateChildValues([messageID:1]) { error, ref in
                completion(error,ref)
            }
        }
        
    }
    
    
}








