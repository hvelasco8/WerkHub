//
//  MainView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 29/1/25.
//

import SwiftUI

struct MainView: View {
    
    @State var selectedtab = 1
    // Variable autentificación
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some View {
        TabView(selection: $selectedtab){
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Buscar")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Chat")
                }
            UserView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Usuario")
                }
        }
        .background(Color(red: 255/255, green: 246/255, blue: 253/255))
        .accentColor(Color(red: 225/255, green: 71/255, blue: 126/255))
        .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}
