//
//  UploadTwitController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/4/24.
//

import UIKit

class UploadTwitController: UIViewController {
    
    //MARK: - Properties
    /**
     Usuario del que vamos a coger los datos
     
     Esta parte es muy importante, ya tenemos los datos del usuario en la vista anterior por lo que declarando esta variable y poniendo abajo un inicializador le pasamos el objeto
     directamente en lugar de hacer una nueva llamada a la API, este concepto es importante
     */
    private let user: User
    /**
     Boton de tweet de la barra de navegacion
     */
    private lazy var tweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue //color de fondo
        button.setTitle("Tweet", for: .normal) //asi se pone el texto
        button.titleLabel?.textAlignment = .center //asi se centra el texto programaticamente
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //cambio del tamaño del texto
        button.setTitleColor(.white, for: .normal) //cambio de color del texto
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleTweet), for: .touchUpInside)
        return button
    }()
    /**
     Imagen de perfil del usuario
     */
    private  let profileImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        imv.setDimensions(width: 48, height: 48)
        imv.layer.cornerRadius = 48/2
        imv.backgroundColor = .twitterBlue
        //la imagen se le asigna en el lifecyrcle
        return imv
    }()
    
    /**
     Text Field para escribir un tweet
     */
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecyrcle

    /**
     Inicializador de la vista con el usuario recibido por parametros, asi nos aseguramos de que el usuario esta si o si
     */
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil) //esta linea es importante, con otro init no funciona
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      configureUI()
    }
    
    //MARK: - Selectors

    @objc func handleCancel(){
        
        self.dismiss(animated: true)

    }
    
    @objc func handleTweet(){
        print("DEBUG: tweet button action...")
    }
    
    //MARK: - Functions
    
    /**
     Metodo que se encarga de configurar la vista
     */
    func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        
        //Vamos a cread una stack view con la imagen y al lado el textField
         let stack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 16)
        
        profileImageView.sd_setImage(with: URL(string: user.profileImage), completed: nil) //asignamos la imagen al perfil
        
        
    
    }
    
}
