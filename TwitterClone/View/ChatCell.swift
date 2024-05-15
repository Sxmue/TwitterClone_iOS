//
//  ChatCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 15/5/24.
//

import UIKit


class ChatCell: UITableViewCell {
    
    var viewModel: ChatCellViewModel?{
        didSet{
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        imv.setDimensions(width: 48, height: 48)
        imv.layer.cornerRadius = 48/2
        imv.backgroundColor = .twitterBlue
        return imv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        
        guard let viewModel = viewModel else {return }
        
        profileImageView.sd_setImage(with: viewModel.profileImage)
        
        let horizontalStack = UIStackView(arrangedSubviews: [usernameLabel,timeStampLabel])
        horizontalStack.spacing = 90
        
        let dataStack = UIStackView(arrangedSubviews: [horizontalStack,contentLabel])
        dataStack.axis = .vertical
        dataStack.spacing = 4
        
        let imageStack = UIStackView(arrangedSubviews: [profileImageView,dataStack])
        imageStack.spacing = 4
        imageStack.alignment = .leading
        
        addSubview(imageStack)
        imageStack.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 8,paddingBottom: 8,paddingRight: 8)
        
        usernameLabel.text = viewModel.usernmeText
        contentLabel.text = viewModel.contentText
        timeStampLabel.text = viewModel.timestampText
    }
    
}
