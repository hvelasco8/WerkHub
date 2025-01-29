//
//  MainView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 29/1/25.
//

import SwiftUI

struct MainView: View {
    // Variable autentificación
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some View {
        VStack {
            // Texto placeholder hasta definir el contenido
            Text("Bienvenido a WerkHub")
                .font(.largeTitle)
                .padding()
            
            // Botón logout para testing
            Button {
                isAuthenticated = false
            } label: {
                Text("Cerrar sesión")
                    .bold()
                    .frame(width: 230, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.red)
                    )
                    .foregroundStyle(.white)
            }
            .padding(.top)
        }
        .navigationTitle("MainView")
    }
}

#Preview {
    MainView()
}
