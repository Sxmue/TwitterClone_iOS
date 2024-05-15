//
//  chatService.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 14/5/24.
//

import UIKit
import Firebase

struct ChatService {
    
    static let shared = ChatService()
    
    func fetchChats(completion: @escaping([Chat]) -> Void){
        
        var chats = [Chat]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return }
        
        DB_USER_CHATS.child(currentUid).observe(.childAdded) { snapshot in
            
            let chatKey = snapshot.key
            
            DB_CHATS.child(chatKey).observeSingleEvent(of: .value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: Any] else {return }
                
                guard let messageUid = dictionary["messageUid"] as? String else {return}
                guard let toUserUid = dictionary["toUser"] as? String else {return}
                
                UserService.shared.fetchUser(uid: toUserUid) { user in
                    
                    MessageService.shared.fetchMessageById(withUid: messageUid) { message in
                        
                        let chat = Chat(uid: chatKey, user: user, message: message)
                        chats.append(chat)
                        completion(chats)
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    func saveChat(toUser: String,messageUid: String,completion: @escaping(Error?, DatabaseReference) -> Void){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return }
        
        let values = ["toUser": toUser,
                      "messageUid": messageUid] as [String : Any]
        
        DB_CHATS.childByAutoId().updateChildValues(values) { error, ref in
            
            guard let key = ref.key else {return }
            
            DB_USER_CHATS.child(currentUid).updateChildValues([key: 1]) { error, ref in
                
                completion(error,ref)
                
            }
            
        }
        
    }
    
    func userHasChat(withUser: String,completion: @escaping(Bool) -> Void){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return }
        
        DB_USER_CHATS.child(currentUid).child(withUser).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
        
        
        
    }
    
}
