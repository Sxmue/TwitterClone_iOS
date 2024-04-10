//
//  TweetCellCollectionViewCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 10/4/24.
//

import UIKit

/**
 Clase que representa una celda para el tweet
 */
class TweetCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
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
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        //Añadimos la imagen de perfil del usuario a la celda
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,left: leftAnchor,
                                paddingTop: 12 ,paddingLeft: 8)
        
        //Ahora los dos textos de la celda vamos a meterlos en una stack view
        let stack = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        stack.axis = .vertical
        stack.spacing = 4
        infoLabel.text = "Leonel Messi @messi"
        
        addSubview(stack)
        
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        addSubview(underline)
        underline.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 0.5)
        
        //Si anclo de abajo y de arriba la vista no se queda bien anclada, solo de arriba es lo correcto
        stack.anchor(top: profileImageView.topAnchor,left: profileImageView.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12 )
        
        //Ahora un stackView para los 4 botones de like retweet...
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        addSubview(actionStack)
        actionStack.centerX(inView: self)

        actionStack.anchor(bottom: underline.topAnchor)
        

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors

    @objc func handleCommentTapped(){
        
        
    }
    
    @objc func handleRetweetTapped(){
        
        
    }
    
    @objc func handleLikeTapped(){
        
        
    }
    
    @objc func handleShareTapped(){
        
        
    }
    
    
    //MARK: - Helpers

}
