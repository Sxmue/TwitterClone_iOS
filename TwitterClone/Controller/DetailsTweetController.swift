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
    var tweet: Tweet
    
    var tweets = [Tweet](){
        didSet {
            collectionView.reloadData()
        }
    }
    
    var actionSheet: ActionSheetLauncher!
    
    //MARK: - Lifecyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchTweetReplies()
        
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
    
    fileprivate func showActionSheet(user: User) {
        self.actionSheet = ActionSheetLauncher(user: user)
        actionSheet.delegate = self
        actionSheet.show()
    }
    
    
    //MARK: - Selectors
    
    //MARK: - API
    
    func fetchTweetReplies(){
        TweetService.shared.fetchReplies(forTweet: tweet) { tweets in
            self.tweets = tweets
            print("DEBUG: Replies traidos correctamente, \(tweets.count)")
        }
    }
    
}
//MARK: - UICollectionView Datasource

extension DetailsTweetController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    
}

//MARK: - CollectionViewFlowDelegate

extension DetailsTweetController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet) //instanciamos nuestro view model con el tweet
        let height = viewModel.size(forWidth: view.frame.width).height //Devuelve un CGSize, pues solo el width
        //Ahora tenemos el valor minimo indispensable para que ocupe de manera optima el caption, ahora a ese tamaño hay que sumarle 80, pera tener 40 de espacio por arriba y 40 por abajo, el caption esta centrado asi que dejara espacio arriba y abajo
        return CGSize(width: view.frame.width, height: height + 260)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TweetDetailsHeader", for: indexPath) as! TweetDetailsHeader
        
        header.tweet = tweet
        
        header.delegate = self
        
        return header
    }
    
    
    
}


//MARK: - TweetDetailsHeaderDelegate

extension DetailsTweetController: TweetDetailsDelegate {
    func handleComment() {
        let nav = UINavigationController(rootViewController: UploadTwitController(user: tweet.user, config: .reply(tweet)))
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true)
    }
    
    
    func showActionSheet() {
        
        //Si el usuario es el current user lo iniciamos normal
        if tweet.user.isCurrentUser {
            showActionSheet(user: tweet.user)
            
        }else {
            
            //Si no lo es chekeamos si lo seguimos con el servicio, para hacer la distincion en el action sheet
            UserService.shared.checkIfUserIsFollowed(uid: tweet.uid) { bool in
                
                if bool {
                    self.tweet.user.isFollowed = true
                }
                    self.showActionSheet(user: self.tweet.user)
                
            }
        }
        
    }
    
    
}


//MARK: - ActionSheetDelegate

extension DetailsTweetController: ActionSheetLauncherDelegate{
    
    func didSelect(option: ActionSheetOptions) {
        
        //A traves del option que tenemos nos permite hacer la distincion de los anumerados muy facilmente
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, ref in
                
                print("Usuario @\(user.username) SEGUIDO con exito")
                
            }
        case .unfollow(let user):
            
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                
                print("Usuario @\(user.username) DEJADO DE SEGUIR con exito")
                
            }
        case .report:
            
            print()
        case .delete:
            
            print()
        }
        
    }
    
    
    
}









