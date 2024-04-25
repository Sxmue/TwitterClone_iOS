//
//  UserTableViewCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 16/4/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
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
        imv.setDimensions(width: 40, height: 40)
        imv.layer.cornerRadius = 40/2
        imv.backgroundColor = .twitterBlue
        return imv
    }()

    /**
     Label de username
     */
    private let usernameLabel: UILabel = {
        let caption = UILabel()

        caption.font = UIFont.boldSystemFont(ofSize: 14)
        caption.text = "Username"
        return caption
    }()

    /**
     label de Fullname
     */
    private let fullnameLabel: UILabel = {
        let caption = UILabel()

        caption.font = UIFont.systemFont(ofSize: 14)
        caption.text = "Fullname"
        return caption
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white

        addSubview(profileImageView)

        // Con la plantilla le hacemos constraint a la izquierday centrado en el eje y
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)

        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)

    }

    func configure() {
        guard let user = user else {return }
        profileImageView.sd_setImage(with: user.profileImageURL)
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }

}
