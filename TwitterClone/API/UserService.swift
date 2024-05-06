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
    static let shared = UserService() // Constante singleton para acceder al servicio de Usuarios
    
    /**
     Funcion para traer a un usuario de la bbdd
     */
    func fetchUser(uid: String, completion: @escaping(User) -> Void ) {
        
        // De esta manera se hace un fetch de datos de manera sencilla a traves de un observador
        DB_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            // snapshot tiene dentro un diccionario de datos con los datos de nuestro usuario
            
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            
            print("DEBUG: El diccionario es \(dictionary)")
            
            // Asi tenemos nuestro usuario unicializado con los datos del diccionario
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user) // llamada al closure que acabamos de poner en los atributos
            // El bloque completion recibe al usuario instanciado
        }
        
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        
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
    func followUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        // Necesitamos guardar en user followers, el uid del usuario logueado, y dentro el uid del usuario al que ha seguido
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        guard currentUserUid != uid else {return }
        
        // Este metodo añade a la base de datos sin sobreescribir otras key que ya haya guardadas
        // Entonces al currentUserUid le añade la key que le hemos pasado al metodo, que sera el uid del usuario al que ha pulsado
        DB_USER_FOLLOWING.child(currentUserUid).updateChildValues([uid: 1]) { _, _ in
            
            DB_USER_FOLLOWERS.child(uid).updateChildValues([currentUserUid: 1], withCompletionBlock: completion)
        }
    }
    
    /**
     Funcion encargada de hacer que el usuario haga unfollow a otro
     */
    func unfollowUser(uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        guard currentUserUid != uid else {return }
        
        DB_USER_FOLLOWING.child(currentUserUid).removeValue { _, _ in
            
            DB_USER_FOLLOWERS.child(uid).child(currentUserUid).removeValue(completionBlock: completion)
        }
        
    }
    
    /**
     Funcion que comprueba si el usuario logueado sigue a otro
     */
    func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        guard currentUserUid != uid else {return }
        
        // De esta manera se comprueba si en la base de datos existe un valor
        DB_USER_FOLLOWING.child(currentUserUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            
            // Con snapshot .exist sabremos si existe en la ruta o no, lo que nos permitira saber si lo seguimos
            completion(snapshot.exists())
        }
        
    }
    
    /**
     Llamada a la API que se va a encargar de traer las stats del usuario
     */
    func fetchUserStats(uid: String, completion: @escaping (userFollowFollowingStats) -> Void) {
        
        // Vamos a obtener cuandos seguidores tiene nuestro usuario, y a cuantos siguen
        DB_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            // de esta manera se accede a todos los resultados del snapshot en array, y cogemos el count
            let followers = snapshot.children.allObjects.count
            print("DEBUG: followers: \(followers)")
            
            DB_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                print("DEBUG: following: \(following)")
                completion(userFollowFollowingStats(followers: followers, following: following))
                
            }
            
        }
        
    }
    
    /**
     Funcion encargada de actualizar los datos del usuario en la bbdd
     */
    func saveUserData(user: User, completion: @escaping (Error?, DatabaseReference) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        //Muy muy importante, como la biografia es opcional te va a salir una alerta rara en el values, al ponerle un valor por defecto se quita
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "bio":user.bio ?? ""]
        
        DB_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        
        
    }
    /**
     Funcion para actualizar la imagen de perfil en la base de datos
     */
    func updateUserProfileImage(image: UIImage, completion: @escaping (String) -> Void){
        
        //Hay que obtener el data porque fireBase Storage solo guarda tipo data
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return }
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        //Necesitamos un nombre de archivo unico, obetenemos uno con NSUUID
        let filename = NSUUID().uuidString
        
        STORAGE_PROFILE_IMAGES.child(filename).putData(imageData) { metadata, error in
            
            //ya esta la imagen subida a storage, ahora con el metodo download URL obtenemos el path
            STORAGE_PROFILE_IMAGES.child(filename).downloadURL { url, error in
                //Obtenemos asi la url de la imagen subida
                guard let url = url?.absoluteString else {return }
                
                //Una vez tenemos la url, solo es cuestion de updatear la info del usuario
                let values = ["profileImage": url]
                
                DB_USERS.child(uid).updateChildValues(values) { error, ref in
                    
                    completion(url)
                }
                
            }
        }
        
    }
    
    func fetchUser(withUsername username: String,completion: @escaping (User) -> Void ){
        
        DB_USER_NAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            
            guard let userUID = snapshot.value as? String else {return }
            
            fetchUser(uid: userUID) { user in
                completion(user)
            }
            
        }
        
    }
    
}
