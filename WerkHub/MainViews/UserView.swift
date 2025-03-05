//
//  UserView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 14/2/25.
//

import SwiftUI

struct UserView: View {
    //Variable autentificación
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)                .ignoresSafeArea()
            // Botón logout para testing
            Button {
                isAuthenticated = false
            } label: {
                Text("Cerrar sesión")
                    .bold()
                    .frame(width: 230, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 225/255, green: 71/255, blue: 126/255))
                    )
                    .foregroundStyle(.white)
            }
            .padding(.top)
        }
    }
}

#Preview {
    UserView()
}
