//
//  ChatFooterView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/5/24.
//

import UIKit

protocol ChatFooterDelegate: AnyObject {
    func didTappedSend(_ footer: ChatFooterView,content: String)
}

class ChatFooterView: UIView {
    
    let textView: InputTextView = {
        let textview = InputTextView()
        
        textview.placeholder.text = "Escribe tu mensaje aqui ..."
        return textview
        
    }()
    
    weak var delegate: ChatFooterDelegate?
    
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
        stack.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        stack.axis = .horizontal
        stack.alignment = .leading
        
        
        button.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func sendTapped(){
        
        guard !textView.text.isEmpty else {return }
        
        delegate?.didTappedSend(self,content: textView.text)
        
        textView.text = ""
    }
    
}
