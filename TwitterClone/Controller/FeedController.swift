//
//  FeedController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit
import SDWebImage

class FeedController: UICollectionViewController{
    
    //MARK: - Propiedades
    
    var user:  User?{
        didSet {
            print("DEBUG: Usuario asignado en FeedController")
            //Cuando se haya asignado correctamente, podemos llamar al metodo que pone la imagen de la izquierda
            configureLeftProfileImage()
        }
        
    }
    
    var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lo primero que vamos a hacer es llamar a un metodo que configure la UI
        configureUI()
        fetchTweets()
        
        
        
        collectionView.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: "TweetCell")
        
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        collectionView.reloadData()
        
        
    }
    //MARK: - API
    
   
    
    func fetchTweets(){
        
        //Primero los traemos
        TweetService.shared.fetchTweets { tweets in
            
            self.tweets = tweets
            
            self.checkIfUserLikedTweets(tweets)
        }
    }
    
    func likeTweets(tweet: Tweet){
        
        TweetService.shared.likeTweet(tweet: tweet) { error, ref in
            
        }
        
    }
    
    fileprivate func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        
        //Despues en local, con este for el cual te permite tambien tener el indice por el que va
        //Comprobamos para cada tweet si se le ha dado me gusta o no
        //Necesitas este for con el indice porque sino no puedes hacer bien referencia al array desde el completion
        
        for (index,tweet) in tweets.enumerated() {
            TweetService.shared.isTweetLiked(tweet: tweet) { result in
                guard result == true else { return }
                self.tweets[index].didLike = result
                
                print("DEBUG: \(self.tweets[index])")
            }
        }
    }
    
    
    //MARK: - Funciones de ayuda
    
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        collectionView.backgroundColor = .white
        
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        view.addSubview(underline)
        underline.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.safeAreaLayoutGuide.leftAnchor
                         ,right: view.safeAreaLayoutGuide.rightAnchor,height: 0.3)
        
        //Lo primero que vamos a hacer es poner el loguito de twitter arriba
        //Esto lo vamos a hacer instanciando un IMAGEVIEW con un UIIMAGE dentro, que son cosas distintas
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        
        imageView.contentMode = .scaleAspectFit //ajusta la imagen al imageview pero manteniendo el aspect ratio
        imageView.setDimensions(width: 44, height: 44) //De esta manera le damos un tamaño fijo, lo que hara que no se mueva a la derecha cuando aparezca la imagen del usuario
        navigationItem.titleView = imageView //La propiedad titleView añade al centro de la barrita de navegacion una vista que hayamos creado, en este caso nuestra imagen
        
    }
    
    /**
     Metodo que se encarga de configurar la imagen de arriba a la izquierda
     */
    func configureLeftProfileImage(){
        
        guard let user = user else {return } //Comprobamos que el usuario ha sido traido primero
        
        //Configuramos la imagen
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32) //Con esta linea se le da a los image view un tamaño concreto
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true //Indicamos que la imagen se quede de la forma del imageview
        //Ahora con la libreria que hemos añadido SDWEBIMAGE podemos asignar la imagen y hacer el fetch en el momento
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
    }
    
    
}

//MARK: - UICollectionView Delegate/DataSource
/**
 Extension para los metodos del collection view
 */
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
        
        //Pasamos el tweet completo a la celda
        let tweet = tweets[indexPath.item]
        
        cell.tweet = tweet // al asignar a una variable optional un valor no optional no uses el "?" o no se asignara
        
        cell.indexPath = indexPath
        
        cell.delegate = self // Nos hacemos delegados de la celda
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailsTweetController(tweet: tweets[indexPath.row]), animated: true)
    }
    
}

//MARK: - UICollectionView DelegateFlowLayout

/**
 Este delegado implementa los metodos para modificar las dimensiones de los objetos en el collection view, los metodos vienen en dos delegados distintos
 
 Las vistas pueden tener mas de un delegado
 */
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    /**
     Esta funcion cambia el alto de las celdas
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row] //sacamos el tweet por el que va asignando a la lista
        let viewModel = TweetViewModel(tweet: tweet) //instanciamos nuestro view model con el tweet
        let height = viewModel.size(forWidth: view.frame.width).height //Devuelve un CGSize, pues solo el width
        //Ahora tenemos el valor minimo indispensable para que ocupe de manera optima el caption, ahora a ese tamaño hay que sumarle 80, pera tener 40 de espacio por arriba y 40 por abajo, el caption esta centrado asi que dejara espacio arriba y abajo
        return CGSize(width: view.frame.width, height: height + 80)
    }
    
    
}

//MARK: - TweetCollectionViewCell Delegate

//A Traves de la adopcion de este protocolo, abstraigo el metodo que quiero ejecutar de la celda a esta vista, lo que me permite usar el NavigationController que tengo aqui
extension FeedController: TweetCellDelegate {
    
    
    func likeTapped(_ cell: TweetCollectionViewCell,_ indexPath: IndexPath?) {
        
        guard var tweet = cell.tweet else {return }

        likeTweets(tweet: tweet) //metodo para procesar el like en la api

        cell.tweet?.didLike.toggle() //este metodo cambia el boolean value auto de manera local
                
        //hay que cambiar el numero de likes en local tambien porque dentro del metodo solo lo actualizamos en la bbdd
        
        if tweet.didLike && tweet.likes > 0 {
            
            tweet.likes = tweet.likes-1
            
        }else{
            
            tweet.likes = tweet.likes+1
        }
        
        tweet.didLike.toggle()
        
        guard let indexPath = indexPath else {return }
        print("Debug: La cosa va bien")
        
        
        tweets[indexPath.row] = tweet
        
        cell.tweet = tweets[indexPath.row]
        
        self.tweets.forEach { tweet in
            print(tweet.didLike)
        }
        
        
        collectionView.reloadData()
    }
    
    func commentTapped(_ cell: TweetCollectionViewCell) {
        guard let user = cell.tweet?.user else { return }
        
        guard let tweet = cell.tweet else {return }
        
        let nav = UINavigationController(rootViewController: UploadTwitController(user: user, config: .reply(tweet)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    
    
    func toUserProfile(_ cell: TweetCollectionViewCell) {
        
        guard let user = cell.tweet?.user else {return }
        
        
        navigationController?.pushViewController(UserProfileController(user: user), animated: true)
        
    }
    
}






