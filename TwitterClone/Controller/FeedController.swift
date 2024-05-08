//
//  FeedController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit
import SDWebImage
import FirebaseAuth


protocol FeedControllerDelegate: AnyObject {
    func didUserLogout(_ controller: FeedController)
}

class FeedController: UICollectionViewController{
    
    //MARK: - Propiedades

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    weak var delegate: FeedControllerDelegate?
    
    var sideMenu = SideMenu()

    private var window: UIWindow?

    
    var user:  User?{
        didSet {
            print("DEBUG: Usuario asignado en FeedController")
            //Cuando se haya asignado correctamente, podemos llamar al metodo que pone la imagen de la izquierda
            configureLeftProfileImage()
            
            guard let user = user else{return }
            sideMenu.user = user
            
        }
    }
    
    var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var blackView: UIView = {
        let view = UIView()

        // Va a ser una view con este constructor, es decir con el white a 0 y el alpha (opacidad= a la mitad
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0

        // Le añadimos un gesture tap para nada mas que se pulse en lo negro se vuelva a la pantalla anterior
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))

        // Y aqui lo añadimos al image view
        view.addGestureRecognizer(tap) // listo

        view.isUserInteractionEnabled = true // importante para que funcione nuestro reconocimiento de gestos

        return view
    }()
    
    
    
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
        
        navigationController?.isNavigationBarHidden = false
        
        view.isUserInteractionEnabled = true

        collectionView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.isUserInteractionEnabled = true

    }
    //MARK: - API
    
    
    func fetchTweets(){
        
        collectionView.refreshControl?.beginRefreshing()
        //Primero los traemos
        TweetService.shared.fetchTweets { tweets in
            self.collectionView.refreshControl?.endRefreshing()
            
            //De esta manera ordenamos los tweets que nos traemos segun el timestamp
            self.tweets = tweets.sorted(by: {$0.timestamp > $1.timestamp})
        }
    }
    
    func likeTweets(tweet: Tweet){
        
        TweetService.shared.likeTweet(tweet: tweet) { error, ref in
            
            //Una vez tenemos completada la funcion de like, creamos la notificacion
            //Pero solo haremos esto si es dandole like, no quitandolo, asi que metemos el guard
            guard !tweet.didLike else { return } //Solo se hara cuando sea un like
            NotificationService.shared.uploadNotification(tweet: tweet,type: .like)
            
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
        
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        collectionView.refreshControl = refresh
        
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSideMenuOpen))

        
        profileImageView.addGestureRecognizer(tap)

        profileImageView.isUserInteractionEnabled = true

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
        
    }
    
    
   @objc func handleSideMenuOpen() {
       
       let scenes = UIApplication.shared.connectedScenes

       let windowScene = scenes.first as? UIWindowScene

       guard let window = windowScene?.windows.first(where: {$0.isKeyWindow}) else {return }

       self.window = window
       
       window.addSubview(blackView)
       
       blackView.frame = window.frame
       
       sideMenu.delegate = self
       
       self.sideMenu.frame = CGRect(x:-500, y: 0, width: 300, height: window.frame.height)
       
       window.addSubview(sideMenu)
              
       UIView.animate(withDuration: 0.5) {
           
           self.sideMenu.frame = CGRect(x:0, y: 0, width: window.frame.width * 0.85, height: window.frame.height)
           self.blackView.alpha = 1

       }
    }
    
    @objc func handleDismiss(){
        
        // Con animacion tambien para quitarla
        UIView.animate(withDuration: 0.5) {
            
            // Le quitamos la opacidad completamente
            self.blackView.alpha = 0
            
            self.sideMenu.frame.origin.x -= 500

            
        }
        
    }
    //MARK: - Selectors
    
    @objc func handleRefresh(){
        fetchTweets()
        
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
    
    func didMentionTapped(withUsername username: String, _ cell: TweetCollectionViewCell) {
        
        UserService.shared.fetchUser(withUsername: username.lowercased()) { user in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(UserProfileController(user: user), animated: true)
            }
        }
    }
    
    
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
        
        navigationController?.isNavigationBarHidden = true
        
        
        navigationController?.pushViewController(UserProfileController(user: user), animated: true)
        
    }
        
    
}



//MARK: - SideMenuDelegate

extension FeedController: SideMenuDelegate {
    
    func didSelectProfileOption(_ sideMenu: SideMenu) {
        
        guard let user = user else {return }
        handleDismiss()
        navigationController?.pushViewController(UserProfileController(user: user), animated: true)
        
    }
    
    func didSelectLogout(_ sideMenu: SideMenu) {
        
        handleDismiss()
        
        delegate?.didUserLogout(self)
        
    }
    
    
    
    
    
    
    
    
}







