//
//  UserProfileController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

class UserProfileController: UICollectionViewController {
    
   //MARK: - Properties
    
    var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecyrcle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors
    
    
    
    
    //MARK: - Helpers

    func configureCollectionView(){
        
        //Registramos nuestra celda personalizada
        collectionView.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: "TweetCell")

        //Registramos la vista personalizada del header, que se hace de esta manera lo cual es completamente nuevo, tambien puedes tener un footer
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeader")
        
        //Para que el collection view ocupe toda la pantalla y no se quede en el safelayout, hay que usar esto
        collectionView.contentInsetAdjustmentBehavior = .never
        
    }

}

//MARK: - UICollectionView Datasource
extension UserProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
    
        return cell
    }
    
}

//MARK: - UICollectionViewHeader

//En esta extension vamos a tener los metodos del delegado para configurar una vista suplementaria
extension UserProfileController {
    //View for funciona igual que cell for por ejemplo
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //Al igual que con una celda, hay un metodo para añadir una vista supplementaria con identificador, el cual hemos implementado antes, ahora y simplemente se personaliza igual que si fuera una celd
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: "ProfileHeader", for: indexPath) as! ProfileHeader
        
        return header
    }
}


//MARK: - UICollectionViewFlowdelegate

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    //Este delegado tiene una cosa nueva, y es que los Collection view tienen un header el cual nos permite hacer la parte de arriba de una vista, de esta manera se implementa
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    
}
