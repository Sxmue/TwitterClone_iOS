//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 18/4/24.
//

import UIKit

//Vamos a reutilizar la vista de poner un tweet para poner un nuevo tweet, o para hacer un repli a otro tweet
//Empezamos con este enumerado

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet) //En el caso de la resuesta a un tweet necesitamos el tweet al que va a responder, de ahi el valor asociado
}
/**
 Esta estructura almacenara los valores que necesitamos en la vista de upload tweet segun el enum de configuracion que hemos creado
 */
struct UploadTweetViewModel {
    
    
    let actionButtonTitle: String
    let placeHolderText: String
    let shouldShowReplyLabel: Bool
    var replyLabelText: String?
    
    //Al crearle un constructor y pasarle config en el parametro, segun lo que haga seleccionado en el enum habra unos valores o otros
    //Despues simplemente rellenamos los campos de la vista con esta estructura
    init(config: UploadTweetConfiguration){
    
        //Ahora segun sea config
        switch config {
        case .tweet:
            
            actionButtonTitle = "Tweet"
            placeHolderText = "¿Que esta pasando?"
            shouldShowReplyLabel = false
            
        case .reply(let tweet): //de esta manera se accede a las propiedades de un valor asociado de un enum
            
            actionButtonTitle = "Reply"
            placeHolderText = "Tweetea tu respuesta"
            shouldShowReplyLabel = true
            replyLabelText = "Respondiendo a @\(tweet.user.username)"
            
        }
    }
}
