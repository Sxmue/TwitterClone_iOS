//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 23/4/24.
//

import UIKit


struct NotificationViewModel {
    
    //MARK: - Properties
    
    let notification: Notification
    
    let type : NotificationType
    
    var notificationMessage: String {
        
        switch type{
        case .follow:
            return " te ha seguido "
        case .like:
            return " dio me gusta a tu tweet "
        case .retweet:
            return " te hizo retweet "
        case .reply:
            return " te ha respondido "
        case .mentions:
            return " te ha mencionado "
        }
    }
    
    var notificationText: NSAttributedString {
        
        let attributed = NSMutableAttributedString(string: notification.user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        
        let append = NSAttributedString(string: notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        
        attributed.append(append)
        
        let timestamp = NSAttributedString(string: timestamptText, attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                             .foregroundColor: UIColor.lightGray])
        attributed.append(timestamp)
        
        return attributed
    }
    
    var timestamptText: String {
        
        //Hacemos timestamp de esta manera, para ver la diferencia entre la notificacion y ahora en tiempo
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "0m"
        
    }
    
    var profileImageUrl: URL? {
        return notification.user.profileImageURL
    }
    
    //MARK: - Lifecycle
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
    }
    
    
    
    
    
    
    
    
    
}
