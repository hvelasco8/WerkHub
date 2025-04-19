//
//  UserModel.swift
//  WerkHub
//
//  Created by Héctor Velasco on 21/4/25.
//

import Foundation

// Modelo alternativo para representar un usuario, usado especialmente al recibir datos como diccionario
struct UserModel {
    var id: String                   // ID único del usuario
    var email: String               // Correo electrónico
    var accountType: String         // Tipo de cuenta: "Artista" o "Promotor"
    var bio: String                 // Biografía del usuario
    var profileImageUrl: String     // URL de la imagen de perfil
    
    // Inicializador que convierte un diccionario [String: Any] en un UserModel
    // Devuelve nil si falta algún campo o hay tipos incompatibles
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let email = dictionary["email"] as? String,
              let accountType = dictionary["accountType"] as? String,
              let bio = dictionary["bio"] as? String,
              let profileImageUrl = dictionary["profileImageUrl"] as? String else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.accountType = accountType
        self.bio = bio
        self.profileImageUrl = profileImageUrl
    }
}
