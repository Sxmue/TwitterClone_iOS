//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//


import UIKit

class NotificationsController: UITableViewController{
    
    //MARK: - Propiedades
    
    private var notifications = [Notification](){
        didSet{
            tableView.reloadData()
        }
    }
    
    
    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        
        fetchNotifications()

        configureUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false

    }

    //MARK: - Helpers
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        navigationItem.title = "Notifications"
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80
        
        //MUY IMPORTANTE ESTO ES NUEVOS
        //iOS te da por defecto un objeto de control para implementar el hacer scrol hacia abajo y que se actualicen los tweets, lo tienen estructuras como el colectionView y los tableView
        let refreshControll = UIRefreshControl()
        tableView.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)


    }
    
    //MARK: - Selectors
    
    /**
     Metodo encargado de refrescar las notificaciones a traves del refresh control
     */
    @objc func handleRefresh(){
        fetchNotifications()
    }
    
    //MARK: - API

    func fetchNotifications(){
        //De esta manera nos referimos al refresh controll, podemos indicarle que empiece la ruletilla a cargar
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
           
            self.notifications = notifications
            self.checkFollowNotifications()
            
            //Ya aqui dentro de esta manera te puedes referir al refresh control, y hacer que pare de cargar
            self.refreshControl?.endRefreshing()
        }
    }
    
    /**
     Metodo que se encarga de chequear en las notificaciones de tipo follow si el usuario se sigue o no
     */
    func checkFollowNotifications(){
        for (index,noti) in self.notifications.enumerated() {
            UserService.shared.checkIfUserIsFollowed(uid: noti.user.uid) { bool in
                if noti.type == .follow{
                    self.notifications[index].user.isFollowed = bool
                }
            }
        }
    }
    
    
    
    //MARK: - TableViewDatasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.notification = notifications[indexPath.row]
        
        cell.delegate = self
        
        cell.indexPath = indexPath
                
        return cell
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = notifications[indexPath.row]
        
        guard let tweetID = notification.tweetID else {return } //Si le damos en la clase notificacion, un valor por defecto al tweetID, el guard let no funciona porque nunca recibe nil siempre recibe algo, hay que cambiar eso
        
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            
            self.navigationController?.pushViewController(DetailsTweetController(tweet: tweet), animated: true)
            
        }
    
    }
    
}


//MARK: - NotificationsCell delegate

extension NotificationsController: NotificationCellDelegate {
    
    func didTapOnFollow(_ cell: NotificationCell,indexPath: IndexPath) {
        
        guard let user = cell.notification?.user else {return }
        
        
        if user.isFollowed{
                
                UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                    
                    self.notifications[indexPath.row].user.isFollowed = false
                    self.tableView.reloadData()
                    
                }
                
            }else{
                
                UserService.shared.followUser(uid: user.uid) { error, ref in
                                        
                    self.notifications[indexPath.row].user.isFollowed = true
                    self.tableView.reloadData()
                }
                
            }
        }
        
        
        
        func didImageTapped(_ cell: NotificationCell) {
            
            print("DEBUG: Deberiamos ir al perfil del usuario")
            
            guard let user = cell.notification?.user else {return }
            
            navigationController?.pushViewController(UserProfileController(user: user), animated: true)
            
        }
    }
    
    






