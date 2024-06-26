//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit
import FirebaseAuth

/**
 Enum encargado de cambiar la imagen del boton segun la opcion del tab seleccionada
 */
enum ActionButtonConfiguration{
    case tweet
    case message
}

// En este proyecto vamos a crear un clon de twitter usando MVVM y haciendo toda la interfaz de manera programatica

// Lo primero que hemos hecho es la estructura de carpetas, y crear este controlador que es un UITabBarController

// Hemos ido al scene delegate y le hemos dicho que la vista principal ahora es esta, ve alli para ver como se hace (tambien se podria haber hecho desde el storyboard)
// Si te fijas para probar hemos hecho que el fondo sea rosa y te hace la distincion entre los tab bar button item y el fondo con distintos tonos de rosa

// Tenemos el tabBar ahora mismo, pero ahora hay que crear los controladores que van dentro de cada tabBar
class MainTabController: UITabBarController {
    
    // MARK: - Propiedades
    
    var user: User? {
        didSet {
            
            print("DEBUG: Usuario asignado a MainTab")
            
            // Lo que haya en este bloque, se seteara UNA VEZ este usuario haya sido asignado y se haya completado el fetch
            // Asi que aqui dentro, pasaremos al usuario a los distintos controllers en los que necesitaremos sus datos
            
            guard let nav1 = viewControllers?[0] as? UINavigationController else {return } // sacamos del tab bar, el primer view controller
            guard let feed = nav1.viewControllers.first as? FeedController else {return }// Sacamos su rootview
            feed.user = user // Una vez lo tenemos, entramos a su propiedad user y asignamos
            feed.delegate = self
            // Asi compartimos las informacion del usuario en las distintas vistas
            
        }
        
    }
        
    //Esta variable almacenara que imagen debe mostrarse en el boton
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    
    // Esta es una nueva manera de instanciar un elemento de manera programatica, añadiendole llaves despues del igual como las propiedades calculadas
    let actionButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue // twitter blue añadido desde extensions
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        return button
        
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        self.tabBar.tintColor = .twitterBlue
        self.delegate = self
        self.view.isUserInteractionEnabled = true
        
        self.tabBar.backgroundColor = .white
        self.view.backgroundColor = .white
        
        
        
        //        logout()
        authenticateUserAndConfigureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.isNavigationBarHidden = true
                
    }
    
    // MARK: - API
    
    /**
     Funcion encargada de authenticar a un usuario
     */
    func authenticateUserAndConfigureUI () {
        
        // Si el usuario no esta logueado, auth nos da este metodo para comprobarlo
        if Auth.auth().currentUser == nil {
            
            // En apple, cuando quieres cambiar de vista sobre la root tienes que hacerlo en el hilo main
            DispatchQueue.main.async {
                
                // De esta manera cambiamos de vista pero obligamos a que la nueva aparezca en full screen, sino aparece como una modal (que tampoco esta mal segun el caso)
                // La instancia de nav es muy importante, hay que hacerla asi si o si porque necesitas el navigation controller para que cambie de ventanas una vez estes en el login, si solo presentas el login no se podra cambiar de ventana por ejemplo a la de sign in
                let nav = UINavigationController(rootViewController: LoginController())
                nav.navigationBar.backgroundColor = UIColor.red
                nav.modalPresentationStyle = .fullScreen // El fix para que se vaya al login y ocupe toda la pantalla
                self.navigationController?.present(nav, animated: true)
                
            }
            print("DEBUG: No hay nadie logueado")
        } else {
            // En cambio, si el usuario esta logueado
            
            // Con este metodo, configuramos e instanciamos todos los ViewControllers para cada tabBar que tengamos
            configureViewControllers()
            
            configureUI()
            
            fetchUser()
        }
        
    }
    
    /**
     Funcion encargada de traer los datos del usuario logueado
     */
    func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        // Consumo del servicio de usuario para el fetch de datos
        UserService.shared.fetchUser(uid: uid) { user in
            UserService.shared.fetchUserStats(uid: user.uid) { data in
                var userAux:User? = user
                userAux?.stats = data
                self.user = userAux
            }
            
        }
        
    }
    
    
    // Vamos a hacer una funcion rapida para desloguearnos hasta que añadamos el boton y poder probar bien la funcion de arriba
    func logout() {
        // Firebase loguea al ultimo usuario añadido en la bbdd automaticamente
        do {
            try Auth.auth().signOut() // Con ese metodo deslogueamos
        } catch let error {
            
            print("DEBUG: Error deslogueando \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Selectors
    /**
     Funcion encargada de abrir la pantalla de escribir un twit
     */
    @objc func actionButtonTap() {
        guard let user = user else { return } // Hacemos unwrap del user que esta optional
        
        var controller: UIViewController
        switch buttonConfig {
        case .tweet:
            controller = UploadTwitController(user: user, config: .tweet)
        case .message:
            controller = ExploreController(config: .messages)
        }
        
        // Necesitamos que sea un navigation controller, para volver atras cuando se escriba el twit
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    // MARK: - Funciones de ayuda
    
    /**
     Metodo que se encarga de asociar un controlador a cada boton del tab bar que tengamos
     */
    func configureViewControllers() {
        
        // Una vez hemos creado cada controllador para cada barButtonItem, el proceso para añadirlos mediante codigo es sencillo
        // Instanciamos cada controlador en esta vista y lo asignamos
        
        // Los ViewControllers tienen un elemento llamado tabBarItem, que te permite cambiar propiedades si estan metidos en un tabBarController, para cada controller le ponemos una imagen en su propiedad
        
        // Acto seguido, vamos a meter cada controlador en un Navigation controller, para que en cada vista se pueda navegar dentro y volver
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout()) // Muy importante ya que va a ser un colecction view
        
        let nav1 = NavigationController(rootViewController: feed) // De esta manera hacemos "Embeed" a cada vista con el navigationController
        
        nav1.tabBarItem.image = UIImage(named: "home_unselected") // Como ahora a nuestra vista la agrupa un navigationController, es la vista "root", le ponemos al navigation el icono, igual en los demas
        
        nav1.navigationBar.isUserInteractionEnabled = true
        
        // Los demas los hacemos con la funcion que nos hemos creado
        
        // Los UITabBarContollers tienen esta propiedad la cual cual te permite añadir todos los view controllers de golpe al tabBar
        // Ahora aqui le pasamos los consiguientes view controllers
        let controller = MessagesController()
        controller.delegate = self
//        delegateMine = controller
        viewControllers = [nav1, // Este lo dejo de ejemplo para ver el funcionamiento interno
                           templateNavigationController(image: UIImage(named: "search_unselected")!, root: ExploreController(config: .userSearch)),
                           templateNavigationController(image: UIImage(named: "like_unselected")!, root: NotificationsController()),
                           templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1")!, root: controller)]
        
    }
    
    /**
     Metodo para hacer "embeed" a los controllers en navigations controllers
     Tambien les asigna la imagen para el tab bar
     */
    func templateNavigationController(image: UIImage, root: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        
        return nav
    }
    
    /**
     Funcion que se va a encargar de configurar la UI de la pagina, por ejemplo cambiando la imagen del boton dependiendo del tab seleccionado
     */
    func configureUI() {
        
        self.view.addSubview(actionButton) // Primero añadimos el boton a nuestra vista
        
        // Y ahora vamos con las constraints
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false // Activamos los constraints manuales
        
        // Ahora el chico del tutorial ha proporcionado una clase llamada Extensions, la cual hace una extension a la clase UI view para proporcionar una manera facil de constrainear una view
        
        // Ante las dudas ir y revisar la extension, tiene varios metodos para diferentes utilidades
        
        // Esto basicamente es, por arriba y por la derecha anclalos al borde del safe area y de la derecha de la pantalla
        // Ponle un poquitin de padding a la derecha para que no este tan al borde
        // El padding bottom es mayor porque se le da desde abajo del todo
        
        // Siempre que no estemos usando un label hay que especificar el ancho y el alto porque tiene que saber de que tamaño es el elemento, en este caso 56x56
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                            paddingBottom: 64, paddingRight: 16,
                            width: 56, height: 56)
        
        // Para hacer el boton redondeado perfecto es el ancho partido 2, en este caso 56
        actionButton.layer.cornerRadius = 56/2
        
        actionButton.addTarget(self, action: #selector(actionButtonTap), for: .touchUpInside) // Manualmente le añadimos el listener al boton el target, con su metodo que esta mas abajo
    }
    
}



//MARK: - NavigationController Extension
extension NavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}



//MARK: - FeedController Delegate

extension MainTabController: FeedControllerDelegate {
    func didUserLogout(_ controller: FeedController) {
        
        logout()
        
        tabBarController?.tabBar.isHidden = true
        
        authenticateUserAndConfigureUI()
        
    }
  
}

//MARK: - Extension TabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    
    /**
     Metodo del tab bar que te devuelve que view controller ha sido seleccionado
     */
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //Aqui tenemos entonces el view controller dentro de cada tab
        let index = viewControllers?.firstIndex(of: viewController)
        
        let imageName = index == 3 ? "mail" : "new_tweet"
        
        actionButton.setImage(UIImage(named: imageName), for: .normal)
        
        buttonConfig = index == 3 ? .message : .tweet
        
    }
}

//MARK: - Extension MessagesController

extension MainTabController: MessagesControllerDelegate{
    func shouldShowActionButton(_ controller: MessagesController) {
        actionButton.isHidden = false
    }
    
    
    func didSelectChat(_ controller: MessagesController) {
        self.tabBarController?.tabBar.isHidden = true
        actionButton.isHidden = true
        
    }
    
}

