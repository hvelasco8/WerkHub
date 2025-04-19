//
//  UserData.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 21/5/25.
//

import Foundation

// Modelo que representa los datos del usuario en la app
struct UserData: Codable, Identifiable {
    
    // Conformidad con Identifiable usando el uid como identificador
    var id: String { uid }
    
    let uid: String                  // ID único del usuario (mismo que en Firebase Auth)
    var accountType: String          // Tipo de cuenta: "Artista" o "Promotor"
    var bio: String                  // Biografía escrita por el usuario
    var email: String                // Email del usuario
    var profileImageUrl: String      // URL de la imagen de perfil (guardada en Firebase Storage)
}
