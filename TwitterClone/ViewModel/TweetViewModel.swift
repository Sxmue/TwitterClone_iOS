//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

//Esta es nuestra primera clase ViewModel, clase la cual va a actuar igual que una capa de servicios, cada minima LOGICA que necesitemos realizar fuera de los componentes de la UI que no sea simplemente asignar algo, debe ir en su ViewModel correspondiente, ayuda al mantenimiento del codigo y a separar la arquitectura de capas
//Ya sea desde calcular un timestamp o hacer un attributed string DEBE ir aqui, en su viewModel
class TweetViewModel {
    
    var tweet: Tweet
    
    lazy var profileImageURL: URL? = {
        return  URL(string: self.tweet.user.profileImage)
    }()
    
    var timestamp: String {
        //Para trabajar con timestamps hay que crear un Formatter
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekday] //Esto indica en que va a devolver nuestro formatter la fecha
        
        formatter.maximumUnitCount = 1 //Asi le dices que unidades de las que acabamos de poner arriba quieres de vuelva, por orden, asi que 1 es segundos
        
        formatter.unitsStyle = .abbreviated //estilo abreviado
        
        return formatter.string(from: tweet.timestamp, to: Date()) ?? "0s" //Este metodo devuelve la diferencia entre dos fechas
    }
    
    lazy var userInfoText: NSAttributedString = {
        let title = NSMutableAttributedString(string: "\(self.tweet.user.fullname)",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(tweet.user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ﹒ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        return title
    }()
    
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
}
