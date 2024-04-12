//
//  FilterCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 12/4/24.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - Properties
    let labelCell: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Prueba"
        return label
    }()
    
   
    
    //Las celdas tienen una propiedad interna que te permite saber si ha sido seleccionada o no, de esta forma lo vemos:
    
    override var isSelected: Bool {
        didSet {
            labelCell.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            
            labelCell.textColor = isSelected ? .twitterBlue : .lightGray
            
        }
        
    }
    
    
    //MARK: - Lifecyrcle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelCell)
        labelCell.center(inView: self)
        

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    
    
    //MARK: - Helpers

    


    
    
}
