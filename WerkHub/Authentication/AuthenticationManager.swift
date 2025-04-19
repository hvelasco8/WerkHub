//
//  AuthenticationManager.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 24/1/25.
//

import Foundation
import FirebaseAuth

// Modelo para guardar los datos básicos del usuario autenticado
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    // Se inicializa con un objeto 'User' que viene de Firebase
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

// Clase que se encarga de todo lo relacionado con el inicio de sesión y registro
final class AuthenticationManager {
    
    // Se crea una instancia compartida para usar esta clase desde cualquier parte de la app
    static let shared = AuthenticationManager()
    
    // Se impide crear otras instancias de esta clase desde fuera
    private init() { }
    
    // Función que crea un nuevo usuario en Firebase usando correo y contraseña
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Función que inicia sesión con un usuario ya registrado
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
