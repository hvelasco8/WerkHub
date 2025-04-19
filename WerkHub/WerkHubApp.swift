//
//  WerkHubApp.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 16/1/25.
//

import SwiftUI
import Firebase

// Punto de entrada principal de la aplicación
@main
struct WerkHubApp: App {
    
    // Se utiliza AppDelegate para configurar Firebase al iniciar la app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        // Indica qué vista se carga al iniciar la aplicación
        WindowGroup {
            LogIn() // Muestra la vista de inicio de sesión
        }
    }
}

// Clase encargada de gestionar eventos del ciclo de vida de la app
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // Este método se ejecuta cuando la app termina de arrancar
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure() // Inicializa Firebase
        return true
    }
}
