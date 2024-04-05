//
//  AuthService.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 5/4/24.
//

import Firebase
import FirebaseDatabase

/**
 
 Estructura encargada de almacenar las credenciales de acceso
 
 */
struct AuthCredentials {
    //Esta estructura nos va a permitir programar los metodos que tienen acceso a la API separandolo de la vista abstrayendolos
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}





/**
 Estructura que se encarga de gestionar nuestro enlace con la API de Firebase
 */
struct AuthService {
    
    static let shared = AuthService() //Instancia de manera static de nuestra propia clase, preguntar a fernando
    
    //MARK: - Metodos principales
    /**
     Metodo que se encarga de registrar a un usuario
     */
    func registerUser(credentials: AuthCredentials, completition: @escaping(Error?,DatabaseReference) -> Void){
        
        saveImage(credentials.profileImage, credentials.email, credentials.password, credentials.fullname, credentials.username,completition)
        
    }
    
    
    //MARK: - Funciones auxiliares

    /**
     Metodo que se encarga de guardar la imagen en la base de datos
     */
    func saveImage(_ image: UIImage,_ email:String , _ password: String, _ fullname: String,_ username: String,_ completition: @escaping(Error?,DatabaseReference) -> Void){
        
        //La imagen ahora que nos llega como parametros vamos a almacenarla en la seccion Storage de firestore, esta seccion lo que almacena son los datos jpeg de la foto, asi que vamos a obtenerlos
        
        guard let imgData = image.jpegData(compressionQuality: 0.3) else {return } //Aqui tenemos los datos jpeg de la imagen
        
        //Ahora las imagenes hay que guardarlas con un nombre unico, asi que vamos a generar uno aleatorio
        let filename = NSUUID().uuidString //ya lo tenemos aqui
        
        //Ahora vamos a decirle donde queremos guardar los datos de nuestra imagen a traves de las constantes que hemos creado
        
        //Primero tenemos que crear la ruta donde va la imagen explicitamente, esto lo hacemos a traves del uuid y las constantes
        
        let path = STORAGE_PROFILE_IMAGES.child(filename) //Ahora mismo, dentro de imagenes de perfil hay un archivo creado con el nombre unico que hemos generado
        
        //Ahora subimos nuestros datos exactamente a esa ruta, osea A ESA RUTA le ponemos literalmente ESOS DATOS, muy intuitivo
        
        path.putData(imgData) { metadata,error in
            
            //Ahora que los datos estsan guardados, firebase le asigna a la imagen una URL con la que puedes obtener la imagen
            //Necesitamos ponersela al usuario en la bbdd, asi que vamos a obtenerla
            path.downloadURL {url, error in
                
                guard let imageProfileURL = url?.absoluteString else {return } //De esta manera obtenemos su url pasada a String
                
                //Ahora que tenemos la imagen procesada, llamamos al metodo de guardar para tener todos los datos juntos y subirlo
                saveUser(imageProfileURL, email, password,fullname, username,completition)
                
                
            }
            
        }
        
    }
    
    /**
     Metodo que se encarga de guardar a un usuario completo en la base de datos
     */
    fileprivate func saveUser(_ image: String,_ email:String , _ password: String, _ fullname: String,_ username: String, _ completition: @escaping(Error?,DatabaseReference) -> Void) {
        //Ahora cuando tenemos la imagen, tenemos que ejecutar todo el codigo de authenticar y guardar un usuario
        
        
        //Como tenemos firebase configurado, y en la seccion de authentificacion hemos activado email y contraseña
        //Podemos llamar al objeto "Auth" de firebase para que haga automaticamente la authenticacion sin tener que hacer nosotros nada
        //En resultado te viene la info DESPUES de haber guardado al usuario
        //Todo el codigo de las llaves se ejecuta una vez se haya completado la operacion, es decir, viene un error o el usuario guardado
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Usuario registrado satisfactoriamente")
            
            //Asi que sabiendo que si no hay error en el resultado tenemos el usuario authenticado
            //Sacamos el uuid unico que le añade firestore al usuario
            guard let uuid = result?.user.uid else {return }
            
            //Ahora vamos a crear un diccionario de datos para asignarlo de golpe al objeto en la bbdd
            
            let data = ["email": email,"password": password,
                        "fullname": fullname,
                        "username": username,
                        "profileImage": image]
            
            //Ahora, con este metodo se guarda en la base de datos de FireStore en iOS
            //Literalmente esto significa coge una referencia de la base de datos, el child "users" que es como hemos llamado a la base de datos, y el metodo updatear datos del hijo a traves de su uuid que le ha puesto authentication lo que hace es actualizar el objeto en base de datos sin modificar los datos que ya tenia asignados
            //Cualquier duda con los metodos de firebase en la documentacion oficial estan muy bien explicados
            //Hemos creado una clase de constantes para no tener que repetir esta linea
            Database.database().reference().child("users").child(uuid).updateChildValues(data,withCompletionBlock: completition)
        }
    }
}
