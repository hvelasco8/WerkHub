//
//  AuthenticationManager.swift
//  WerkHub
//
//  Created by Héctor Velasco on 24/1/25.
//

import Foundation
import FirebaseAuth

// Estructura para usuarios
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init(){ }
    
    // Función para la creacción de usuario en Firebase
    func createUser(email: String, password: String) async throws ->  AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Función para el registro de usuario en Firebase
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
