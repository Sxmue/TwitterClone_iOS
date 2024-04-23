//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 23/4/24.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    
    func didImageTapped(_ cell: NotificationCell)
}

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
    
    weak var delegate: NotificationCellDelegate?
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didImageTapped))
        
        imv.addGestureRecognizer(tapGesture)
    
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = true

        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationsLabel])
        stack.axis = .horizontal
        stack.isUserInteractionEnabled = true
        stack.spacing = 8
        stack.alignment = .center
        
        //MUY IMPORTANTE, EN LOS TABLE VIEW CELL, SI QUIERES QUE SE RECONOZCA EL TAP GESTURE TIENES QUE AÑADIR EL ELEMENTO AL CONTENT VIEW, NO ADDSUVIEW SIN MAS, SINO NO RECONOCERA EL GESTO PORQUE AL TAP DE LA CELDA ESTARA POR ENCIMA SIEMPRE
        
        contentView.addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configure(){
        guard let notification = notification else {return }
        
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        notificationsLabel.attributedText = viewModel.notificationText
        
    }
    
    //MARK: - Selectors
    
    @objc func didImageTapped(){
        
        delegate?.didImageTapped(self)
        
    }

}
