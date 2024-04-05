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
        
        //Creamos nuestro objetos de credenciales
        let credentials = AuthCredentials.init(email: email, password: password, fullname: fullName, username: username, profileImage: image)
        
        //Gestionamos el guardado en la bbdd
        AuthService.shared.registerUser(credentials: credentials)
        
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
    
}
