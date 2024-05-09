//
//  MessageCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let messageView = MessageView()
    
    var message: Message?{
        didSet{
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemPink
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        guard let message = message else {return }
        
        let viewModel = MessageCellViewModel(message: message)
        
        let height = viewModel.size(forWidth: 250).height + 20
        
        messageView.setDimensions(width: 250, height: height)
        
        messageView.layer.cornerRadius = height/2
        addSubview(messageView)
        messageView.centerY(inView: self)
        messageView.anchor(right: rightAnchor,paddingRight: 4)
        
    }
     
}
