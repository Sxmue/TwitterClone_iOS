//
//  MessageCellViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/5/24.
//

import UIKit

class MessageCellViewModel {
    
    let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    
    
    
    func size(forWidth width: CGFloat) -> CGSize {
        let view = MessageView()
        view.content.text = message.content
        view.content.numberOfLines = 0
        view.content.lineBreakMode = .byWordWrapping
        view.content.translatesAutoresizingMaskIntoConstraints = false
        view.content.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view.content.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
