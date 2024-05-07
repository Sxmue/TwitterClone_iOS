//
//  SideMenuCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 7/5/24.
//

import UIKit


class SideMenuCell: UITableViewCell{
    
    var option: SideMenuOptions?{
        didSet{
            configure()
        }
    }
    
    lazy var  image: UIImageView = {
        let imv = UIImageView()
        
        imv.setDimensions(width: 60, height: 60)
        
        return imv
    }()
    
    
    lazy var optionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.textColor = .white
        return label
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .twitterBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(){
        
        guard let option = option else {return }
        
        addSubview(image)
        image.centerY(inView: self)
        image.image = UIImage(named: option.imgName)
        
        addSubview(optionLabel)
        optionLabel.centerY(inView: image,leftAnchor: image.rightAnchor,paddingLeft: 20)
        
        optionLabel.text = option.title
        
    }
    
}
