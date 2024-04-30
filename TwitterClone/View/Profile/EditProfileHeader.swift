//
//  EditProfileHeader.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 30/4/24.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject{
    func didChangeImage(_ header: EditProfileHeader)
}
class EditProfileHeader: UIView{
    
    //MARK: - Properties
    
    let user: User
    
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        
        return iv
    }()
    
    private lazy var  changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Cambiar Foto de Perfil", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        return  button
    }()
    
    //MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        addSubview(profileImageView)
        //Centrada y 16 px hacia arriba para poner abajo el boton, esto esta hecho con la extension de ayuda que tenemos
        profileImageView.center(inView: self,yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        
        addSubview(changePhotoButton)
        //Estara dentrado en el eje x, pero anclado por arriba a dejajo de la imagen, por lo que estara centrado y abajo con un poco de padding
        changePhotoButton.centerX(inView: self,topAnchor: profileImageView.bottomAnchor,paddingTop: 8)
        
        profileImageView.sd_setImage(with: user.profileImageURL)
        backgroundColor = .twitterBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors

    @objc func handleChangeProfilePhoto(){
        
        delegate?.didChangeImage(self)
        
        
    }
    

    
    
    
    
}
