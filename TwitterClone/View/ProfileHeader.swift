//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

/**
 Componente personalizado que sera el header de el collection controller del usuario
 */
class ProfileHeader: UICollectionReusableView {
    
    //Con UICollectionReusableView creamos una vista rehusable para el resto del colection view
    
    //MARK: - Properties
    
    //MARK: - Lifecyrcle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors

    
    //MARK: - Helpers


    
    
}
