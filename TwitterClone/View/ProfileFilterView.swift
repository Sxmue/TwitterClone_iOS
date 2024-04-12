//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 12/4/24.
//

import UIKit

//Delegado para que cuando se seleccione una celda se haga algo concreto exteriormente, en este caso la animacion del cambio de barrita
protocol ProfileFilterViewDelegate: AnyObject {
    
    func animateSelector(_ view: ProfileFilterView, didSelect indexpath: IndexPath)
        
        
    
}

/**
 UIView que va a albergar nuestro collection view, para tener los tres botones de filtrado en el perfil del usuario
 */
class ProfileFilterView: UIView{
    
    //MARK: - Properties
    lazy var  collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    weak var delegate: ProfileFilterViewDelegate? //Delegado para la funcionalidad de animacion del seleccionado
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self) //Importante que existe esto, para que te añada automaticamente las constraints para que la vista ocupe todo el disponible
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    
    
    
    //MARK: - Helpers


    
    
    
}

//MARK: - UICollectionViewFlowDelegate

extension ProfileFilterView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! ProfileFilterCell
        
        
        return cell
    }
    
    
}


//MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Y ahora en el did select ejecutamos la funcion del delegado, para que la clase exterior pueda ejecutar la animacion de cambio
        delegate?.animateSelector(self, didSelect: indexPath)
        
    }
    
    
}

//MARK: - UICollectionViewFlowDelegate

extension ProfileFilterView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Vamos a tener 3 zeldas asi que es importante dividir el ancho entre 3
        return CGSize(width: frame.width/3, height: frame.height)
    }
    
    //Las celdas tienen un espacio por defecto en los collection view, de esta manera lo eliminamos
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



