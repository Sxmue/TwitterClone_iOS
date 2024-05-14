//
//  MessageView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class MessageView: UIView{
    
    var viewModel: MessageViewViewModel?{
        didSet{
            configure()
        }
    }
    
    lazy var content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Texto de prueba por defecto hola hola hola"
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        addSubview(content)
        guard let viewModel = viewModel else {return }
        
        content.font = viewModel.font
        content.textColor = viewModel.fontColor
        backgroundColor = viewModel.backgroundColor
        
        content.center(inView: self)
        content.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 8,paddingBottom: 8,paddingRight: 8)
    }
    
}
