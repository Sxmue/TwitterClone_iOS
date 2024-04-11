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
    //MARK: - API
    
    func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
            
            self.tweets = tweets
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
        profileImageView.sd_setImage(with: URL(string: user.profileImage), completed: nil)
        
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
        
        
        
        return cell
    }
        
}

//MARK: - UICollectionView DelegateFlowLayout

/**
 Este delegado implementa los metodos para modificar las dimensiones de los objetos en el collection view, los metodos vienen en dos delegados distintos
 
 Las vistas pueden tener mas de un delegado
 */
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Con view.frame accedes a las dimensiones de la vista completa, asi ocuparan las celdas todo el ancho y 200 de alto
        return CGSize(width: view.frame.width, height: 120)
    }
    
}
