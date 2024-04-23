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

    //MARK: - Helpers
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        navigationItem.title = "Notifications"
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80


    }
    
    //MARK: - API

    func fetchNotifications(){
        
        NotificationService.shared.fetchNotifications { notifications in
            
            print("Hemos traido \(notifications.count) notificaciones")
            self.notifications = notifications
        }
    }
    
    
    //MARK: - TableViewDatasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.notification = notifications[indexPath.row]
        cell.awakeFromNib()
        
        return cell
    }
    
}





