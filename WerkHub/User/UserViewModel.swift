//
//  UserViewModel.swift
//  WerkHub
//
//  Created by Héctor Velasco on 21/4/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Network

// ViewModel que gestiona la lógica del usuario en la app (capa intermedia entre vistas y datos)
class UserViewModel: ObservableObject {
    @Published var user: UserModel?           // Modelo de usuario cargado desde Firestore
    @Published var errorMessage: String?      // Mensaje de error si ocurre algún fallo
    @Published var isLoading = false          // Indicador de carga para mostrar en la vista
    
    private let db = Firestore.firestore()    // Referencia a la base de datos
    private let monitor = NWPathMonitor()     // Monitor para detectar conexión a internet
    private let queue = DispatchQueue(label: "NetworkMonitor") // Cola dedicada para la red
    
    // Al iniciar el ViewModel, se empieza a monitorear el estado de red
    init() {
        startNetworkMonitoring()
    }
    
    // Al destruirse el ViewModel, se detiene el monitoreo
    deinit {
        monitor.cancel()
    }
    
    // Comienza a observar el estado de la conexión a internet
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status != .satisfied {
                    self?.errorMessage = "No hay conexión a internet"
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    // Función para obtener los datos del usuario desde Firestore
    func fetchUser(completion: (() -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            handleError("Usuario no autenticado", completion: completion)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.handleError("Error al obtener datos: \(error.localizedDescription)", completion: completion)
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self?.handleError("No se encontraron datos del usuario", completion: completion)
                    return
                }
                
                // Se crea un modelo de usuario a partir del diccionario recibido
                self?.user = UserModel(dictionary: data)
                completion?()
            }
        }
    }
    
    // Función para actualizar los datos del usuario en Firestore
    func updateUser(accountType: String, bio: String, profileImageUrl: String?, completion: ((Bool) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            handleError("Usuario no autenticado", completion: { completion?(false) })
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Se preparan los campos que se van a actualizar
        var updateData: [String: Any] = [
            "accountType": accountType,
            "bio": bio,
            "lastUpdated": FieldValue.serverTimestamp()
        ]
        
        // Se añade la URL de imagen si existe
        if let url = profileImageUrl {
            updateData["profileImageUrl"] = url
        }
        
        // Se actualiza el documento del usuario
        db.collection("users").document(uid).updateData(updateData) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.handleError("Error actualizando datos: \(error.localizedDescription)", completion: { completion?(false) })
                    return
                }
                
                // Una vez actualizado, se vuelve a cargar el usuario
                self?.fetchUser(completion: { completion?(true) })
            }
        }
    }
    
    // Maneja los errores: actualiza mensaje y estado de carga
    private func handleError(_ message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.isLoading = false
            completion?()
        }
    }
}
