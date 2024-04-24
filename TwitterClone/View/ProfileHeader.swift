//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func dismissView(_ header: ProfileHeader)
    func handleEditProfileFollow(_ header: ProfileHeader)
    
}

/**
 Componente personalizado que sera el header de el collection controller del usuario
 */
class ProfileHeader: UICollectionReusableView {
    
    //Con UICollectionReusableView creamos una vista rehusable para el resto del colection view que podemos usar de header o de footer
    
    //MARK: - Properties
    
    weak var delegate: ProfileHeaderDelegate?
    
    //Necesitamos los datos del usuario para setear ciertas cosas de la vista, pues asi es la manera mas limpia y correcta de hacerlo
    //Al asignar esta propiedad
     var user: User? {
        didSet {
            //Se llama automaticamente a este metodo
            configure()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .twitterBlue
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.isUserInteractionEnabled = true
        
        
        return view
    }()
    
    lazy var barSelection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .twitterBlue
        
        view.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,height: 1)
        
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        
        button.setDimensions(width: 30, height: 90)

        button.clipsToBounds = true

        return button
    }()
    
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.backgroundColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.backgroundColor = .twitterBlue
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 20 / 2
        return iv
    }()
    
        lazy var ProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(handleProfileFollowButton), for: .touchUpInside)
        return button
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Biografia de prueba que ocupe mas de una linea para las pruebas me gusta la pizza"
        label.numberOfLines = 3 //no mas de 3 lineas
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Leonel Messi"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let username = UILabel()
        username.font = UIFont.systemFont(ofSize: 16)
        username.textColor = .lightGray
        username.text = "@Messi"
        return username
    }()
    
    var filter = ProfileFilterView() //La vista que contiene los 3 botones de filtro dentro
    
    private lazy var followingLabel: UILabel = {
        
        let label = UILabel()
        
        //añadimos un gesture tap para que detecte al pulsar sobre el, y ir a la vista de a quien sigo
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true //Necesario para que reconozca el gesto
        label.addGestureRecognizer(followTap)
        
        //añadimos texto
        label.text = "0 Following"
        
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        
        let label = UILabel()
        
        //añadimos un gesture tap para que detecte al pulsar sobre el, y ir a la vista de a quien sigo
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true //Necesario para que reconozca el gesto
        label.addGestureRecognizer(followTap)
        
        //añadimos texto
        label.text = "0 Followers"
        return label
    }()
    
    

    
    //MARK: - Lifecyrcle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        filter.delegate = self
        
        //Contenedor azul arriba
        addSubview(containerView)
        containerView.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor,height: 108)
        
        //Imagen perfil
        addSubview(profileImage)
        profileImage.isUserInteractionEnabled = true
        profileImage.anchor(top: containerView.bottomAnchor,left: leftAnchor,paddingTop: -24,paddingLeft: 8)
        
     
        //Botton de Follow
        addSubview(ProfileFollowButton)
        ProfileFollowButton.setDimensions(width: 100, height: 36)
        ProfileFollowButton.layer.cornerRadius = 36/2
        ProfileFollowButton.anchor(top: containerView.bottomAnchor,right: rightAnchor,paddingTop: 12,paddingRight: 12)
        
        //Biografia
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel,bioLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: profileImage.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 12,paddingRight: 12)
        
        addSubview(filter)
        filter.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 50)
        
        //Barrita para el filtro seleccionado
        addSubview(barSelection)
        barSelection.anchor(left: leftAnchor,bottom: bottomAnchor,width: frame.width/3,height: 1)
        
        //stack para los seguidores/siguiente
        let followStack = UIStackView(arrangedSubviews: [followingLabel,followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        addSubview(followStack)
        followStack.anchor(top: stack.bottomAnchor,left: leftAnchor,paddingTop: 4,paddingLeft: 12)
        
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor,left: leftAnchor,paddingTop: 10,paddingLeft: 16)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors

    @objc func handleBack(sender : UIButton){
        
        print("Boton pulsado")
        delegate?.dismissView(self)
    }
    
    @objc func handleProfileFollowButton(){
        
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingTapped(){
        
    }
    
    @objc func handleFollowersTapped(){
        
        
    }
    
    
    //MARK: - Helpers
    /**
     Metodo encargado de instanciar un viewmodel y settear todos los campos que necesiten del usuario
     */
    func configure(){
        
        guard let user = user else {return }
        
        fullnameLabel.text = user.fullname
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        usernameLabel.text = viewModel.usernameText
        
        followersLabel.attributedText = viewModel.followersString
        
        followingLabel.attributedText = viewModel.followingString
        
        profileImage.sd_setImage(with: user.profileImageURL)
        
        ProfileFollowButton.setTitle(viewModel.buttonTittle, for: .normal)
        
        
    }

    
    
}


//MARK: - ProfileFilterDelegate
//delegado para ejecutar la animacion del componente encima de las celdas, de la barrita azul
extension ProfileHeader: ProfileFilterViewDelegate{
    
    func animateSelector(_ view: ProfileFilterView, didSelect indexpath: IndexPath) {
        
        //Ahora esto es muy importante, el metodo celll for Item at normalmente nunca lo llamamos se hace automaticamente, pero ese metodo se puede llamar para obtener la celda de vuelta sin problema
        //De esta manera sacamos la celda de vuelta, ya tenemos este metodo rellenado devolviendo la celda que queremos y el index path te devuelve la que esta seleccionada
        guard let cell = view.collectionView.cellForItem(at: indexpath) as? ProfileFilterCell else {return }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.barSelection.frame.origin.x = cell.frame.origin.x
        }
        
    }
    
}
