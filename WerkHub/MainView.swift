//
//  MainView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 29/1/25.
//

import SwiftUI

// Vista principal de la aplicación, con navegación entre las distintas secciones
struct MainView: View {
    
    // Pestaña actualmente seleccionada
    @State var selectedtab = 1
    
    // Indica si el usuario ha iniciado sesión
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false

    // Configuración inicial de la barra de pestañas
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 253/255, alpha: 1)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        // Navegación mediante pestañas
        TabView(selection: $selectedtab){
            
            // Sección de inicio
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
            
            // Sección de búsqueda
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Buscar")
                }
            
            // Sección de chat
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Chat")
                }
            
            // Sección del perfil de usuario
            UserView(isAuthenticated: $isAuthenticated)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Usuario")
                }
        }
        // Color para la pestaña activa
        .accentColor(Color(red: 225/255, green: 71/255, blue: 126/255))
    }
}

#Preview {
    MainView()
}
