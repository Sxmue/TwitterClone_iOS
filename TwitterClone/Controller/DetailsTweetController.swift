//
//  DetailsTweetController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 17/4/24.
//

import UIKit

/**
 Esta sera la ventana correspondiente a hacer tap en un tweet
 
 Sera un collectionview con un header igual que el perfil de usuario
 */
class DetailsTweetController: UICollectionViewController {
    
    //MARK: - Properties
    let tweet: Tweet
    
    let tweets = [Tweet]()
    
    //MARK: - Lifecyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    //Inicializador para almacenar el tweet que necesitamos en la vista
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureCollectionView(){
        
        
        collectionView.register(TweetDetailsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TweetDetailsHeader")
        
        
        collectionView.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: "TweetCell")
        
        
    }
    
    
    //MARK: - Selectors
    
    //MARK: - API
    
}
    //MARK: - UICollectionView Datasource
    
    extension DetailsTweetController {
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 4
            
        }
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
            
            
            
            return cell
        }
    
        
    }
    
    //MARK: - CollectionViewFlowDelegate

extension DetailsTweetController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TweetDetailsHeader", for: indexPath) as! TweetDetailsHeader
        
        return header
    }
    
    
    
}





