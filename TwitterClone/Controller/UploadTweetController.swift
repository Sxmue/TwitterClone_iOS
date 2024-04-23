//
//  UploadTwitController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/4/24.
//

import UIKit

class UploadTwitController: UIViewController {
    
    //MARK: - Properties
    
    //Nos creamos esta propiedad, la cual almacenara en que modo va a estar la vista
    private let config: UploadTweetConfiguration
    
    private lazy var viewModel = UploadTweetViewModel(config: config) //Ahora con nuestro config configurado, instanciamos el viewmodel
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
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Probando cosas"
        return label
    }()
    
    /**
     Text Field para escribir un tweet
     */
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecyrcle

    /**
     Inicializador de la vista con el usuario recibido por parametros, asi nos aseguramos de que el usuario esta si o si
     */
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config //Añadido a posteriori, para decir en que modo iniciamos la vista
        super.init(nibName: nil, bundle: nil) //esta linea es importante, con otro init no funciona
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      configureUI()
        
        switch config {
        case .tweet:
            print("DEBUG: poniendo un tweet nuevo")
            
        case .reply(let tweet):
            print("Respondiendo a \(tweet.caption)")

        }
    }
    
    //MARK: - Selectors

    @objc func handleCancel(){
        
        self.dismiss(animated: true)

    }
    
    /**
     Metodo que se encarga de subir el tweet
     */
    @objc func handleTweet(){
        guard let text = captionTextView.text else {return }
        
        guard !text.isEmpty else {
            print("DEBUG: el texto esta vacio, saliendo...")
            self.dismiss(animated: true)
            return }
        
        //Consumo del servicio de la API para subir tweets
        TweetService.shared.uploadTweet(caption: text,type: config){ error, ref in
            
            //MUY IMPORTANTE,ASI SE HACE REFERENCIA A SI ES UN CASO CONCRETO O OTRO
            //config es el valor de un anum, pues con case.reply miramos si es un reply, te lo rellena el IDE Automaticamente
            //Si el caso es una reply, se mandara una notificacion de reply
            if case .reply(let tweet) = self.config {
                
                NotificationService.shared.uploadNotification(tweet: tweet,type: .reply)
                
            }
            
            if let error = error {
                
                print("DEBUG: Error uploading tweet \(error.localizedDescription)")
            }
            
            
            
            self.dismiss(animated: true)
            
        }
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
         let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        
        //Preguntar a Fernando
        imageCaptionStack.alignment = .leading
        
        
//        view.addSubview(imageCaptionStack)
//        imageCaptionStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 16)
        
        //stack vertical para almacenar la foto y el caption por un lado, y arriba el reply label
    
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
//        stack.alignment = .leading
//        stack.layer.borderWidth = 3
//        stack.layer.borderColor = UIColor.red.cgColor
        view.addSubview(stack)
////
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 16)
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel //segun el booleano se enseña o no el mensaje de reply
        
        captionTextView.placeholder.text = viewModel.placeHolderText
        
        profileImageView.sd_setImage(with: URL(string: user.profileImage), completed: nil) //asignamos la imagen al perfil

        guard let replytext = viewModel.replyLabelText else { return}
        
        replyLabel.text = replytext
        
        
        
    
    }
    
}
