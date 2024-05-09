//
//  ChatFooterView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/5/24.
//

import UIKit

class ChatFooterView: UIView {
    
    let textView: InputTextView = {
        let textview = InputTextView()
        
        textview.placeholder.text = "Escribe tu mensaje aqui ..."
        return textview
        
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Enviar", for: .normal)
        
        button.backgroundColor = UIColor.white
        button.setDimensions(width: 60, height: 30)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [textView,button])
        addSubview(stack)
        stack.addConstraintsToFillView(self)
        stack.axis = .horizontal
        stack.alignment = .leading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
