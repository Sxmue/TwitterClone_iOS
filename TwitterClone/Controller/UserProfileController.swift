//
//  UserProfileController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

class UserProfileController: UICollectionViewController{
    
   //MARK: - Properties
    
    private var user: User
        
    private var tweets = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    
    
    
    //MARK: - Lifecyrcle
    
    init(user: User) {
        self.user = user
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isUserInteractionEnabled = true
        
        collectionView.backgroundColor = .white

        definesPresentationContext = false
        


        
        configureCollectionView()
        
        fetchUserTweets()
        
        checkIfUserIsFollowed()
        
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        navigationController?.isNavigationBarHidden = true
        

                
//        self.navigationController?.preferredStatusBarStyle = .darkContent;

        
    }
    

    
    //MARK: - Selectors
    
    
    
    
    //MARK: - API
    
    func fetchUserTweets(){
        
        TweetService.shared.fetchUserTweets(forUser: user) { tweet in
            print(tweet)
            self.tweets = tweet
        }
    }
    
    func checkIfUserIsFollowed(){
        
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { bool in
            self.user.isFollowed = bool
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats(){
        UserService.shared.fetchUserStats(uid: user.uid) { data in
            
            self.user.stats = data
            self.collectionView.reloadData()
        }
        
    }

    
    
    
    
    //MARK: - Helpers

    func configureCollectionView(){
        
        //Registramos nuestra celda personalizada
        collectionView.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: "TweetCell")
        
        //Registramos la vista personalizada del header, que se hace de esta manera lo cual es completamente nuevo, tambien puedes tener un footer
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeader")
        
        //Para que el collection view ocupe toda la pantalla y no se quede en el safelayout, hay que usar esto
        collectionView.contentInsetAdjustmentBehavior = .never
//        view.safeAreaLayoutGuide.layoutFrame.inset(by: UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0))
//        additionalSafeAreaInsets = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        
        

        
    }
    

}

//MARK: - UICollectionView Datasource
extension UserProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
        
        //Pasamos el tweet completo a la celda
        let tweet = tweets[indexPath.item]
        
        cell.tweet = tweet // al asignar a una variable optional un valor no optional no uses el "?" o no se asignara
        
    
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
        
        collectionView.superview?.bringSubviewToFront(header)

        
        header.delegate = self
        
        header.isUserInteractionEnabled = true
        header.user = user
        
        
        
        return header
    }
}


//MARK: - UICollectionViewFlowdelegate

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    
    //Este delegado tiene una cosa nueva, y es que los Collection view tienen un header el cual nos permite hacer la parte de arriba de una vista, de esta manera se implementa
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    
}

//MARK: - ProfileHeaderDelegate
extension UserProfileController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        
        if user.isCurrentUser {
            
            print("Aun hay que implementar la vista de editar usuario")
            return
        }
        
        //Ya tenemos el usuario en userProfile, porque para acceder a esta vista hay que pasarle el usuario en el que se ha hecho click en la declaracion, en el init
        //asi que lo cogemos de ahi directamente
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, db in
                
                //Cuando cambiamos alguna de las propiedades del usuario, hay que recargar el collection view, eso permitira llamar a las funciones de nuevo y que el boton cambie
                self.user.isFollowed = false
                self.collectionView.reloadData()
                
            }
            
        }else{
            
            UserService.shared.followUser(uid: user.uid) { error,db in
                //Cuando cambiamos alguna de las propiedades del usuario, hay que recargar el collection view, eso permitira llamar a las funciones de nuevo y que el boton cambie
                self.user.isFollowed = true
                
                NotificationService.shared.uploadNotification(user: self.user, type: .follow)
                
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    func dismissView(_ header: ProfileHeader) {
        navigationController?.popViewController(animated: true)
    }
    
    
}



