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
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        guard let message = message else {return }
        
        print("DEBUG: El mensaje en esta celda es : \(message.content)")

        let viewModel = MessageCellViewModel(message: message)
        
        messageView.content.text = viewModel.message.content
        
        
        //TODO: - Refactorizar esto al viewModel
        addSubview(messageView)
        messageView.centerY(inView: self)
        let size = messageView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        messageView.setDimensions(width: size.width + 8, height: size.height + 30)
        messageView.layer.cornerRadius =  ( size.height + 30 ) / 2
        messageView.anchor(right: rightAnchor,paddingRight: 4)
        let screenPercent = frame.width * 0.40
        messageView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: screenPercent).isActive = true
                

//        let size = viewModel.size(forWidth: 400)
//        
//        messageView.setDimensions(width: 400, height: size.height + 20)
//        
//        messageView.layer.cornerRadius = (size.height + 20 ) / 2
//        addSubview(messageView)
//        messageView.centerY(inView: self)
//        messageView.anchor(right: rightAnchor,paddingRight: 4)
        
    }
     
}
