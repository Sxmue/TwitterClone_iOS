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
        
        //TODO: - mirar aqui como llamar a completion solo cuando sea el ultimo mensaje
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
    
    
    
    func saveChat(toUser: String,messageUid: String,completion: @escaping(Chat) -> Void){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return }
        
        let values = ["toUser": toUser,
                      "messageUid": messageUid] as [String : Any]
        
        let valuesToUser = ["toUser": currentUid,
                            "messageUid": messageUid] as [String : Any]
        
        DB_CHATS.childByAutoId().updateChildValues(values) { error, ref in
            
            guard let key = ref.key else {return }
            
            fetchChat(byUid: key) { chat in
                completion(chat)

            }
            
            DB_USER_CHATS.child(currentUid).updateChildValues([key: toUser]) { error, ref in
                
                
            }
            
        }
        
        DB_CHATS.childByAutoId().updateChildValues(valuesToUser) { error, ref in
            
            guard let key = ref.key else {return }
            
            DB_USER_CHATS.child(toUser).updateChildValues([key: currentUid]) { error, ref in
                
//                completion(error,ref)
                
            }
            
        }
        
    }
    
    func userHasChat(withUser: String,completion: @escaping(Bool) -> Void){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return }
        
        DB_USER_CHATS.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.exists() {
                DB_USER_CHATS.child(currentUid).observe(.childAdded) { snapshot in
                    
                    guard let toUser = snapshot.value as? String else {return }
                    
                    completion(toUser == withUser)
                    
                }
            }else {
                completion(false)
                
            }
            
        }
        
    }
    
    func updateChatMessage(forChat chatid: String,withMessage message: Message, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else {return }
        
        DB_CHATS.child(chatid).updateChildValues(["messageUid": message.messageId]) { error, ref in
    
            DB_USER_CHATS.child(message.toUser).observe(.value) { snapshot in
                for child in snapshot.children {
                    guard let childSnapshot = child as? DataSnapshot else {return }
                    guard let toUser = childSnapshot.value as? String else {return }
                    let chatKey = childSnapshot.key
                    
                    if currentUid == toUser{
                        DB_CHATS.child(chatKey).updateChildValues(["messageUid": message.messageId]){ error, ref in
                            
                            completion(error,ref)
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    func fetchChat(byUid uid: String, completion: @escaping(Chat) -> Void){
        
        DB_CHATS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            
            guard let messageUid = dictionary["messageUid"] as? String else {return}
            guard let toUser = dictionary["toUser"] as? String else {return}
            
            UserService.shared.fetchUser(uid: toUser) { user in
                
                MessageService.shared.fetchMessageById(withUid: messageUid) { message in
                    
                    let chat = Chat(uid: uid, user: user, message: message)
                    completion(chat)
                    
                }
            }
        }
    }
    
    func putChatlisteners(chatKey id:String,toUser: String,completion: @escaping(Chat) -> Void){
        
        DB_CHATS.child(id).observe(.childChanged){ snapshot in
            guard let key = snapshot.value as? String else {return }
            UserService.shared.fetchUser(uid: toUser) { user in
                
                MessageService.shared.fetchMessageById(withUid: key) { message in
                    
                    let chat = Chat(uid: id, user: user, message: message)
                    completion(chat)
                    
                }
            }
        }
        
    }
    
}
