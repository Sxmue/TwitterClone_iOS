//
//  TweetCellCollectionViewCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 10/4/24.
//

import UIKit

// ESTO ES MUY MUY IMPORTANTE

// Necesitamos que cuando pulsemos en un elemento concreto de la celda se vaya al perfil del usuario en este caso el imageview cambie de vista, pero claro queremos que sea el Navigation controller que esta en la vista padre de este elemento el que te lleve a la vista

// Si no eres una clase Controller, ViewController, UICollectionController... NO PUEDES PRESENTAR UN NUEVO NAVIGATION CONTROLLER, no puedes llamar a present

// Y necesitas que esa imagen cambie de vista, entonces necesitas usar el navigation controller de tu vista PADRE

// Para ello vamos a crear un DELEGADO con el metodo target que estamos poniendo en el listener de la foto, eso implicara que las vistas que se conformen a ese protocolo obtendran ese metodo. Conformando haciendose el delegado de esta vista en la vista padre tendremos acceso a ese metodo, es una abstraccion complicada

// La estructura de un delegado es un poco complicada, asi que vamos a ir paso a paso

// De esta manera creamos un protocolo, una interfaz, lo de despues de los dos puntos significa que cualquier clase puede adoptarlo
protocol TweetCellDelegate: AnyObject {

    func toUserProfile(_ cell: TweetCollectionViewCell) // Tenemos este protocolo, con este metodo que recibe una celda, sin mas

    func commentTapped(_ cell: TweetCollectionViewCell) // para cuando le demos retweet desde dentro
    // Ahora pasamos a la propiedad

    func likeTapped(_ cell: TweetCollectionViewCell, _ indexPath: IndexPath?)
}

/**
 Clase que representa una celda para el tweet
 */
class TweetCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    // Esta variable es la que usaremos para comunicarnos con el delegado, con la clase que sea nuestro Delegado
    weak var delegate: TweetCellDelegate? // Literalmente es nuestro delegado TweetCellDelegate, desde aqui accederemos a la version del metodo que se implante EN LA CLASE QUE NOS ADOPTE

    var indexPath: IndexPath?

    var tweet: Tweet? {

        didSet {
            // Este metodo setea los valores internamente en la celda cuando este variable cambie
            configure()
        }
    }

    /**
     Imagen de perfil del usuario
     */
    private lazy var profileImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        imv.setDimensions(width: 48, height: 48)
        imv.layer.cornerRadius = 48/2
        imv.backgroundColor = .twitterBlue
        // la imagen se le asigna en el lifecyrcle

    // Queremos añadir un listener a la imagen para que cuando cliques se vaya a la vista del perfil, pero el imageView no tiene un add tarjet como tal, asi que las opciones serian poner un boton con imagen O poner un listener de gestos de esta manera:

        // Si quieres añadir target o gestures aqui tiene que ser lazy asi ya te deja poner self

        // Asi creamos un "reconocedor de gestos" con su target
        let tap = UITapGestureRecognizer(target: self, action: #selector(toProfileView))

        // Y aqui lo añadimos al image view
        imv.addGestureRecognizer(tap) // listo

        imv.isUserInteractionEnabled = true // importante para que funcione nuestro reconocimiento de gestos

        return imv
    }()
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "→ replying to @Messi"
        
        return label
    }()

    private let captionLabel: UILabel = {
        let caption = UILabel()

        caption.font = UIFont.systemFont(ofSize: 14)
        caption.numberOfLines = 0
        caption.text = "Texto de prueba"
        return caption
    }()

    private let infoLabel = UILabel()

    private lazy var commentButton: UIButton = {
        let button = Utilities().createCellImageButton(imgName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return  button
    }()

    private lazy var retweetButton: UIButton = {
        let button = Utilities().createCellImageButton(imgName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return  button
    }()

    private lazy var likeButton: UIButton = {
        let button = Utilities().createCellImageButton(imgName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return  button
    }()

    private lazy var shareButton: UIButton = {
        let button = Utilities().createCellImageButton(imgName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return  button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white


        // Ahora los dos textos de la celda vamos a meterlos en una stack view
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.spacing = 4
        captionStack.distribution = .fillProportionally
        
        //Juntamos la imagen, con los label de la derecha en un stackView
        //Un stack con otro dentro
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionStack])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.alignment = .leading
        
        //Ahora que tenemos la imagen y los dos label al ladito vamos a meter todo en oootro estack view, pero con el texto de replying de arriba
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        // Si anclo de abajo y de arriba la vista no se queda bien anclada, solo de arriba es lo correcto
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4,paddingLeft: 12, paddingRight: 12 )
        
        
        //La linea separadora de abajo
        let underline = UIView()
        underline.backgroundColor = .lightGray
        addSubview(underline)
        underline.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)

        // Ahora un stackView para los 4 botones de like retweet...

        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72 // Espacio de 72, el cual se ajusta dependiendo de la pantalla en la que se ejecuta
        addSubview(actionStack)
        actionStack.centerX(inView: self) // con el metodo de la extension que creamos al principio, se centra facilmente

        actionStack.anchor(bottom: underline.topAnchor, paddingBottom: 8)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleCommentTapped() {

        delegate?.commentTapped(self)

    }

    @objc func handleRetweetTapped() {

    }

    @objc func handleLikeTapped() {

        delegate?.likeTapped(self, self.indexPath)

    }

    @objc func handleShareTapped() {

    }

    // EN EL METODO DE VERDAD EN EL QUE SE GESTION EL LISTENER
    @objc func toProfileView() {

       // Se hace dentro una llamada al metodo del delegado, para ejecutar el codigo que se ponga en la otra clase
        delegate?.toUserProfile(self)

        // Esto nos va a permitir ejecutar este metodo, en una clase EXTERIOR, teniendo acceso a las propiedades y metodos de la OTRA CLASE
        // En este caso, necesitamos el NavigationController de la CLASE PADRE EXTERIOR

    }

    // MARK: - Helpers

    func configure() {

        guard let tweet = tweet else {return }

        captionLabel.text = tweet.caption

        // Vamos a aplicar el ViewModel por primera vez
        let viewModel = TweetViewModel(tweet: tweet)

        // como estamos creando un objeto URL a traves de la imagen del usuario que tiene el twit, eso ya es logica que aqui NO deberia estar
        // Asi que vamos a hacerlo a traves del viewModel
        // NO puede haber LOGICA en los componentes por minima que sea
        profileImageView.sd_setImage(with: viewModel.profileImageURL)

        // Ahora nuestro infolabel necesita un attributed String, y vamos a realizarlo con su ViewModel
        // Recuerda que para asignar attributed string no se usa text sino attributed text
        infoLabel.attributedText = viewModel.userInfoText

        likeButton.tintColor = viewModel.likeTintColor // Con tint color se cambia el fondo de un boton

        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReply
        
        replyLabel.text = viewModel.replyText

    }
}
