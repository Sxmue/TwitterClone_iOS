//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 23/4/24.
//

import UIKit

/**
 clase que representa una celda en la vista de notificaciones
 */
class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    
    var notification: Notification? {
        didSet{
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        
        imv.addGestureRecognizer(tap)
    
        imv.isUserInteractionEnabled = true
        
        return imv
    }()
    
    let notificationsLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Texto de prueba para el label"
        return label
    }()
    
    //MARK: - Lifecycle

    
    override func awakeFromNib() {
        
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationsLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor,paddingLeft: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    //MARK: - Helpers
    func configure(){
        guard let notification = notification else {return }
        
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        notificationsLabel.attributedText = viewModel.notificationText
        
    }
    
    //MARK: - Selectors
    
    @objc func handleProfileImageTapped(){
        
        
    }

}
