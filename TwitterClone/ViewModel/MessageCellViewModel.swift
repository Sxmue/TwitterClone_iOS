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
        view.text.text = message.content
        view.text.numberOfLines = 0
        view.text.lineBreakMode = .byWordWrapping
        view.text.translatesAutoresizingMaskIntoConstraints = false
        view.text.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view.text.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
