//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

/**
 Componente personalizado que sera el header de el collection controller del usuario
 */
class ProfileHeader: UICollectionReusableView {
    
    //Con UICollectionReusableView creamos una vista rehusable para el resto del colection view que podemos usar de header o de footer
    
    //MARK: - Properties
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .twitterBlue
                
        view.addSubview(backButton)
        
        backButton.anchor(top: view.topAnchor,left: view.leftAnchor,paddingTop: 42,paddingLeft: 16)
        
        backButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    lazy var barSelection: UIView = {
        let view = UIView()
        
        view.backgroundColor = .twitterBlue
        
        view.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,height: 1)
        
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.backgroundColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.backgroundColor = .twitterBlue
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 20 / 2
        return iv
    }()
    
    private lazy var ProfileFollowButton: UIButton = {
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
    
    var filter = ProfileFilterView()

    
    //MARK: - Lifecyrcle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        filter.delegate = self
        
        //Contenedor azul arriba
        addSubview(containerView)
        containerView.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor,height: 108)
        
        //Imagen perfil
        addSubview(profileImage)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors

    @objc func handleBack(){
        
        print("DEBUG: Pulsado hacia atras")
    }
    
    @objc func handleProfileFollowButton(){
        
        print("DEBUG: Pulsado boton follow")
    }
    
    
    //MARK: - Helpers


    
    
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
