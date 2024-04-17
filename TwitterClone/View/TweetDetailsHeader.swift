//
//  TweetDetailsHeader.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 17/4/24.
//

import UIKit

class TweetDetailsHeader: UICollectionReusableView {
    //MARK: - Properties
    
    private lazy var profileImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        imv.setDimensions(width: 48, height: 48)
        imv.layer.cornerRadius = 48/2
        imv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toProfileView))
        
        imv.addGestureRecognizer(tap)
        
        imv.isUserInteractionEnabled = true
        
        return imv
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
    
    private let captionLabel: UILabel = {
        let caption = UILabel()
        
        caption.font = UIFont.systemFont(ofSize: 20)
        caption.numberOfLines = 0
        caption.text = "Texto de prueba"
        return caption
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33 PM ﹒ 01/28/2020"
        return label
    }()
    
    
    
    //MARK: - Lifecyrcle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,labelStack])
        stack.axis = .horizontal
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor,left:leftAnchor,paddingTop: 20,paddingLeft: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func toProfileView(){
        
    }
    
    @objc func handleCommentTapped(){
        
       
    }
    
    @objc func handleLikeTapped(){
        
    }
    
    @objc func handleRetweetTapped(){
        
        
    }
    
    @objc func handleShareTapped(){
        
        
    }

}
