//
//  SideMenu.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 6/5/24.
//

import UIKit


class SideMenu: UIView {
    
    //MARK: - Properties
    
    var user: User?{
        didSet{
            configure()
        }
    }
    
    
    private lazy var profileImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        imv.setDimensions(width: 64, height: 64)
        imv.layer.cornerRadius = 64/2
        imv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toProfileView))

        imv.addGestureRecognizer(tap)

        imv.isUserInteractionEnabled = true 

        return imv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    
    
    //MARK: - Helpers

    func configure(){
        
        backgroundColor = .twitterBlue

        tintColor = .white
        
        guard let user = user else {return }
        let viewModel = SideMenuViewModel(user: user)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor,left: leftAnchor,paddingTop: 0,paddingLeft: 12)
        profileImageView.sd_setImage(with: user.profileImageURL)
        
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        stack.axis = .vertical
        stack.spacing = 8
        addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 12)
        
        fullnameLabel.text = viewModel.fullnameText
        
        usernameLabel.text = viewModel.usernameText

        
        
    }
    
    
    @objc func toProfileView() {
        
        print("DEBUG: A la vista de perfil del usuario")
    }
    
}
