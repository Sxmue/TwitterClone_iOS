//
//  registrationController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth



class RegistrationController: UIViewController{
    
    //MARK: - Propiedades
    
    private let imgPicker = UIImagePickerController() //Image picker para seleccionar la foto que queremos
    
    private var currentImage: UIImage?
    
    
    private let logoImageButton: UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        
        return btn
        
    }()
    
    private let singButton : UIButton = {
        
        let button = Utilities().twitterButton(withText: "Sing Up")
        
        return button
    }()
    
    //Necesitamos el texto de los dos text input, asi que los creamos fuera
    var emailTextField: UITextField = {
        
        return Utilities().createTextField(withPlaceholder: "Email")
    }()
    
    var passwordTextField: UITextField = {
        
        let tf = Utilities().createTextField(withPlaceholder: "Password")
        
        tf.isSecureTextEntry = true //De esta manera hacemos que sea un campo de contraseña, con los puntitos
        
        return tf
    }()
    
    //Necesitamos el texto de los dos text input, asi que los creamos fuera
    var fullNameTextField: UITextField = {
        
        return Utilities().createTextField(withPlaceholder: "Full Name")
    }()
    
    var userNameTextField: UITextField = {
        
        let tf = Utilities().createTextField(withPlaceholder: "Username")
        
        return tf
    }()
    
    //El contenedor de la vista de la imagen y el text input juntos
    private lazy var  fullNameContainer: UIView = {
        
        //Aqui creamos la vista contenedora de la imagen y el text field juntos a traves de nuestro metodo de utilities
        let view = Utilities().createTwitterTextInput(img: "ic_mail_outline_white_2x-1", tf: fullNameTextField)
        return view
    }()
    
    
    //El contenedor de la vista de la imagen y el text input
    private lazy var userNameContainer: UIView = {
        
        //Aqui creamos la vista contenedora de la imagen y el text field juntos a traves de una extension
        let view = UIView()
        view.createTextInput(view,imageName: "ic_person_outline_white_2x",tf:userNameTextField)
        return view
    }()
    
    
    //El contenedor de la vista de la imagen y el text input juntos
    private lazy var  emailContainer: UIView = {
        
        //Aqui creamos la vista contenedora de la imagen y el text field juntos a traves de nuestro metodo de utilities
        let view = Utilities().createTwitterTextInput(img: "ic_mail_outline_white_2x-1", tf: emailTextField)
        return view
    }()
    
    
    //El contenedor de la vista de la imagen y el text input
    private lazy var passwordContainer: UIView = {
        
        //Aqui creamos la vista contenedora de la imagen y el text field juntos a traves de una extension
        let view = UIView()
        view.createTextInput(view,imageName: "ic_lock_outline_white_2x",tf:passwordTextField)
        return view
    }()
    
    
    //Este componente son los botoncitos de abajo, los de "Tienes una cuenta...?"
    private lazy var haveAccountButton: UIButton = {
        let btn = Utilities().attributedButton("Ya tienes una cuenta?", " Log In")
        
        //Las constraints de este boton hay que añadirlas abajo, despues del UIView
        return btn
    }()
    
    //MARK: - Lifecyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - Selectores
    
    @objc func toLoginView(){
        
        //Para volver podemos hacerlo asi
        // navigationController?.pushViewController(LoginController(), animated: true)
        
        //O de esta manera, este metodo hace que se vuelve a la vista anterior de la pila del navigation controller
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addPhoto(){
        
        present(imgPicker, animated: true)
        
    }
    
    
    
    @objc func signHandler(){
        
        //Cogemos los datos de los campos
        guard let email = emailTextField.text else {return }
        guard let password = passwordTextField.text else {return }
        guard let fullName = fullNameTextField.text else {return }
        guard let username = userNameTextField.text else {return }
        
        guard let image = currentImage else {
            print("Hay que seleccionar una imagen")
            return
        }
        
        //Gestionamos la imagen en la bbdd
        saveImageToDatabase(image,email,password,fullName,username) //He tenido que refactorizar toda la obtencion de la imagen a un metodo por la estructura del curso
        
        
        print("Debug: Email is \(email)")
        print("Debug: Password is \(password)")
                
        
    }
    
    
    //MARK: - Funciones de ayuda
    func configureUI(){
        
        logoImageButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        singButton.addTarget(self, action:#selector(signHandler) , for: .touchUpInside)
        
        self.view.backgroundColor = .twitterBlue
        
        self.view.addSubview(logoImageButton)//Añadimos la imagen a la vista
        
        logoImageButton.centerX(inView: self.view, topAnchor: self.view.safeAreaLayoutGuide.topAnchor)
        
        logoImageButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer,passwordContainer,fullNameContainer,userNameContainer,singButton])
        stack.axis = .vertical //Con esto le dice que agrupe en vertical las cosas
        stack.spacing = 20 //El pequeño espacio que deja entre cada stackeo
        self.view.addSubview(stack)
        
        
        stack.anchor(top: logoImageButton.bottomAnchor,left: self.view.leftAnchor,right: self.view.rightAnchor,paddingLeft:32,paddingRight: 32)
        
        haveAccountButton.addTarget(self, action: #selector(toLoginView), for: .touchUpInside)
        view.addSubview(haveAccountButton)
        haveAccountButton.anchor(left: self.view.leftAnchor,bottom: self.view.safeAreaLayoutGuide.bottomAnchor,right: self.view.rightAnchor)
        
        
        
        //-----IMG Picker Delegate ------
        
        imgPicker.delegate = self //Nos hacemos delegados
        
        imgPicker.allowsEditing = true //permitimos editar la foto
        
        
    }
    
}



//MARK: - ImagePicker Delegate

//De esta manera se hace un delegado correctamente, separando los metodos del delegado en un extension

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let img = info[.editedImage] as? UIImage else {return }
        
        currentImage = img
        
        //normlamente si la imagen te da problemas al mostrarse, deberias ponerle a la imagen que lo haga con el modo de renderizado original aunque no suele hacer falta
        
        logoImageButton.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
        
        logoImageButton.layer.cornerRadius = 128 / 2
        logoImageButton.layer.masksToBounds = true //Este metodo hace que todas las subcapas que tengan que ver con este elemento se acoplen a el, por lo que hacemos el boton redondo y con este metodo la imagen se ADAPTA al boton
        
        //El boton, tiene dentro un image view y el image view dentro tiene la imagen
        
        logoImageButton.imageView?.contentMode = .scaleAspectFit //Porque claro el boton no muestra una imagen por arte de magia, tiene dentro su image view, asi que podemos acceder a las propiedades de su imageview
        
        logoImageButton.layer.borderColor = UIColor.white.cgColor
        
        logoImageButton.layer.borderWidth = 3
        picker.dismiss(animated: true)
        
    }
    
    func authentifyUser(_ email: String, _ password: String, _ fullName: String, _ username: String, _ imageProfileURL: String) {
        
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
                        "fullname": fullName,
                        "username": username,
                        "profileImage": imageProfileURL]
            
            //Ahora, con este metodo se guarda en la base de datos de FireStore en iOS
            //Literalmente esto significa coge una referencia de la base de datos, el child "users" que es como hemos llamado a la base de datos, y el metodo updatear datos del hijo a traves de su uuid que le ha puesto authentication lo que hace es actualizar el objeto en base de datos sin modificar los datos que ya tenia asignados
            //Cualquier duda con los metodos de firebase en la documentacion oficial estan muy bien explicados
            //Hemos creado una clase de constantes para no tener que repetir esta linea
            Database.database().reference().child("users").child(uuid).updateChildValues(data) { error, database in
                
                print("DEBUG: Guardado correctamente")
                
                self.navigationController?.pushViewController(MainTabController(), animated: true)
                
            }
        }
    }
    
    
    /**
     Metodo que se encarga de guardar una imagen en el Storage de Firebase
     */
    func saveImageToDatabase (_ image: UIImage,_ email:String , _ password: String, _ fullname: String,_ username: String){
                
        //La imagen ahora que la tenemos, vamos a almacenarla en la seccion Storage de firestore, esta seccion lo que almaceta son los datos jpeg de la foto, asi que vamos a obtenerlos
        
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
            path.downloadURL {[weak self] url, error in
                
                guard let imageProfileURL = url?.absoluteString else {return } //De esta manera obtenemos su url pasada a String
                
                
                //Ahora cuando tenemos la imagen, tenemos que ejecutar todo el codigo de authenticar y guardar un usuario
                
                self?.authentifyUser(email, password, fullname, username, imageProfileURL)
                
            }
            
        }
        
    }
    
    
    
}
