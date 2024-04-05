//
//  File.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit

/**
 Vista encargada del login
 */
class LoginController: UIViewController {
    
    //MARK: - Propiedades
    
    //La imagen del logo
    private let logoImageView: UIImageView = {
        
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFit
        imv.clipsToBounds = true
        imv.image = UIImage(named: "TwitterLogo")
        return imv
        
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
    
    //Boton de login
    private let loginButton : UIButton = {
        
        let button = Utilities().twitterButton(withText: "Login")
        
        return button
    }()
    
    //Este componente son los botoncitos de abajo, los de "Tienes una cuenta...?"
    private lazy var dontHaveAccountButton: UIButton = {
        let btn = Utilities().attributedButton("No tienes una cuenta?", " Sign up")
        
        //Las constraints de este boton hay que añadirlas abajo, despues del UIView
        return btn
    }()
    
    
    
    
    //MARK: - Lifecyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dontHaveAccountButton.addTarget(self, action: #selector(toSingUpView), for: .touchUpInside)

        navigationController?.navigationBar.isHidden = true //Forzamos ocultar la barra de navegacion superior ya que en esta vista no la queremos, pero si queremos navegar entre login y sing in
        navigationController?.navigationBar.barStyle = .black //Asi cambiamos como se ve la hora y la cobertura arriba
        configureUI()
        
    }
    
    
    //MARK: - Selectores

    @objc func login(){
        
    }
    
    @objc func toSingUpView(){
        
        let controller = RegistrationController() //Instanciamos la vista a la que queremos ir
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    //MARK: - Funciones de ayuda
    func configureUI(){
        self.view.backgroundColor = .twitterBlue
        
        self.view.addSubview(logoImageView)//Añadimos la imagen a la vista
        
        logoImageView.centerX(inView: self.view, topAnchor: self.view.safeAreaLayoutGuide.topAnchor) //Este es un metodo de la extension añadida por el muchacho, en el que te centra la view que quieras con el pading top que quieras ponerle
        
        logoImageView.setDimensions(width: 150, height: 150) //Este tambien es un metodo del extension el cual cambia el tamaño de una view al que le pongas, lo bajamos un poquito porque era enorme sino
        
        //Para añadir los dos textInput vamos a usar algo nuevo, un StackView
        //Ya sabes que stackview coge todo lo que le metas y te lo centra automaticamente una cosa encima de la otra
        //Añadimos tambien el boton, el cual adoptara automaticamente el ancho del stackview
        let stack = UIStackView(arrangedSubviews: [emailContainer,passwordContainer,loginButton])
        stack.axis = .vertical //Con esto le dice que agrupe en vertical las cosas
        stack.spacing = 20 //El pequeño espacio que deja entre cada stackeo
        self.view.addSubview(stack)
        
        //Si el stack view no pusiera correctamente los anchos de las cosas, hay una propiedad que se llama distribution que te permite indicarle que quieres que reparta el espacio equitativamente a los elementos que tenga dentro
        
        stack.anchor(top: logoImageView.bottomAnchor,left: self.view.leftAnchor,right: self.view.rightAnchor,paddingLeft:32,paddingRight: 32)

        //Esta parte es muy importante, lo que vaya con constraints a la vista principal, como el stack view o este boton, debe ir inicializado y constraineado en el viewdidload no en las propiedades calculadas
        self.view.addSubview(dontHaveAccountButton)
        
        
        dontHaveAccountButton.anchor(left: self.view.leftAnchor,bottom: self.view.safeAreaLayoutGuide.bottomAnchor,right: self.view.rightAnchor)
    }
    
}
