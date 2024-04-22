//
//  TweetDetailsHeader.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 17/4/24.
//

import UIKit

protocol TweetDetailsDelegate: AnyObject {
    
    func showActionSheet()
    func handleComment()
        
}

class TweetDetailsHeader: UICollectionReusableView {
    //MARK: - Properties
    
    weak var delegate: TweetDetailsDelegate?
    
    var tweet: Tweet? {
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toProfileView))
        
        imv.addGestureRecognizer(tap)
        
        imv.isUserInteractionEnabled = true
        
        return imv
    }()
    
    private var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Leonel Messi"
        return label
    }()
    
    private var usernameLabel: UILabel = {
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
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        view.addSubview(topDivider)
        topDivider.anchor(top: view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 8,height: 0.2)
      
        let statsStack = UIStackView(arrangedSubviews: [retweetsLabel,likesLabel])
        statsStack.axis = .horizontal
        statsStack.spacing = 12
        
        view.addSubview(statsStack)
        statsStack.centerY(inView: view)
        statsStack.anchor(left: view.leftAnchor,paddingLeft: 16)
        
        
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        view.addSubview(bottomDivider)
        bottomDivider.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,height: 0.2)
        
        return view
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0 Retweets"
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        label.text = "0 Likes"
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
        captionLabel.anchor(top: stack.bottomAnchor,left:leftAnchor,right: rightAnchor,paddingTop: 12,paddingLeft: 16,paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor,paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 12,height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        addSubview(actionStack)
        //Con centrarlo en el eje x y anclarlo abajo es suficiente
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor,paddingBottom: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    func configure(){
        
        //Unwrap a nuestro tweet
        guard let tweet = tweet else {return }
        
        //Instanciamos nuestro view model de los Tweets
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: tweet.user.profileImageURL)
        dateLabel.text = viewModel.detailsHeaderTimestamp
        retweetsLabel.attributedText = viewModel.retweetAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        
        
        likeButton.tintColor = viewModel.likeTintColor //Con tint color se cambia el fondo de un boton
        
        likeButton.imageView?.image = viewModel.likeButtonImage
        
    }
    
    

    //MARK: - Selectors
    
    @objc func toProfileView(){
        
    }
    
    @objc func handleCommentTapped(){
        
        delegate?.handleComment()
       
    }
    
    @objc func handleLikeTapped(){
        
    }
    
    @objc func handleRetweetTapped(){
        
        
    }
    
    @objc func handleShareTapped(){
        
        
    }
    
    @objc func showActionSheet(){
        delegate?.showActionSheet()
        
    }

}
