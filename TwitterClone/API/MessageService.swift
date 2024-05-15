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
                
                var message = Message(messageId: messageUid, dictionary: dictionary)
                
                message.isSended = message.fromUser == uid ? true : false
                
                messages.append(message)
                completion(messages)
            }
            
        }
        
    }
    
    
    func saveMessage(content: String ,toUser destinationUid: String,completion: @escaping(Error?, DatabaseReference,String) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        let values = ["timestamp": Int(NSDate().timeIntervalSince1970),
                      "content": content,
                      "fromUser": uid,
                      "toUser": destinationUid] as [String : Any]
        
        DB_MESSAGES.childByAutoId().updateChildValues(values) { error, ref in
            guard let messageID = ref.key else {return }
            
            DB_USER_MESSAGES.child(uid).child(destinationUid).updateChildValues([messageID:1]) { error, ref in
                
                DB_USER_MESSAGES.child(destinationUid).child(uid).updateChildValues([messageID:1]) { error, ref in
                    
                    completion(error,ref,messageID)
                }
            }
        }
        
    }
    
    func fetchMessageById(withUid uid:String, completion: @escaping(Message) -> Void){
        
        DB_MESSAGES.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            
            let message = Message(messageId: uid, dictionary: dictionary)
            
            completion(message)
        }
        
    }
    
    func updateMessage(messageUid: String,content: String,completion: @escaping(Error?, DatabaseReference) -> Void ){
        
        DB_MESSAGES.child(messageUid).updateChildValues(["content:": content]) { error, ref in
            
            completion(error,ref)
            
        }
        
        
        
    }
    
    
}








