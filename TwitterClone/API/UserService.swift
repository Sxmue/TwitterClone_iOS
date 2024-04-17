//
//  UserService.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/4/24.
//
import UIKit
import Firebase
import FirebaseDatabase

/**
 Servicio encargado de gestionar la base de datos con el usuario
 */
struct UserService {
    static let shared = UserService() //Constante singleton para acceder al servicio de Usuarios
    
    /**
     Funcion para traer a un usuario de la bbdd
     */
    func fetchUser(uid: String,completion: @escaping(User) -> Void ){
        
        //De esta manera se hace un fetch de datos de manera sencilla a traves de un observador
        DB_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                
            //snapshot tiene dentro un diccionario de datos con los datos de nuestro usuario
            
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            
            print("DEBUG: El diccionario es \(dictionary)")
            
            //Asi tenemos nuestro usuario unicializado con los datos del diccionario
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user) //llamada al closure que acabamos de poner en los atributos
            //El bloque completion recibe al usuario instanciado
        }
        
        
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void){
        
        var users = [User]()
        
        DB_USERS.observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            
            let user = User(uid: snapshot.key, dictionary: dictionary)
            
            users.append(user)
            
            completion(users)
        }
    }
    
    /**
     Funcion encargada de hacer que el usuario logueado siga a otro
     */
    func followUser(uid: String, completion: @escaping (Error?,DatabaseReference) -> Void){
        
        //Necesitamos guardar en user followers, el uid del usuario logueado, y dentro el uid del usuario al que ha seguido
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        guard currentUserUid != uid else {return }
        
        //Este metodo añade a la base de datos sin sobreescribir otras key que ya haya guardadas
        //Entonces al currentUserUid le añade la key que le hemos pasado al metodo, que sera el uid del usuario al que ha pulsado
        DB_USER_FOLLOWING.child(currentUserUid).updateChildValues([uid: 1]) { error, database in
            
            DB_USER_FOLLOWERS.child(uid).updateChildValues([currentUserUid: 1], withCompletionBlock: completion)
            

        }
        
    }
}
