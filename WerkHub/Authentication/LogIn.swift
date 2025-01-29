//
//  ContentView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 16/1/25.
//

import SwiftUI
import FirebaseAuth

struct LogIn: View {
    // Variables para el inicio de sesión del usuario
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    // Función para la autentificación del usuario
    private func signIn() async {
        do {
            let user = try await AuthenticationManager.shared.signIn(email: email, password: password)
            print("Usuario autenticado: \(user.uid)")
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }
    }
    
    var body: some View {
        NavigationStack {
            // Si el usuario ya está autenticado, se le dirige directamente a Main View
            if isAuthenticated {
                MainView()
            } else {
                ZStack {
                    // Fondo
                    Color(red: 255/255, green: 246/255, blue: 253/255)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(Color(red: 255/255, green: 217/255, blue: 245/255))
                        .frame(width: 1000, height: 400)
                        .rotationEffect(.degrees(135))
                        .offset(y: -320)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 450)
                    
                    // Contenido
                    VStack(spacing: 20) {
                        
                        // Logo
                        Image("WerkHub_Text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        // Campos personalizados
                        CustomTextField(placeholder: "Email", text: $email)
                        CustomSecureField(placeholder: "Contraseña", text: $password)
                        
                        // Mostrar mensaje de error si no existe la cuenta
                        if errorMessage != nil {
                            Text("No se ha encontrado una cuenta con ese email y/o contraseña.")
                                .foregroundColor(.red) // Color rojo para el mensaje de error
                                .font(.caption)
                                .padding(.top, 10)
                        }
                        
                        // Botón de inicio de sesión
                        Button {
                            Task {
                                await signIn()
                            }
                        } label: {
                            Text("Iniciar Sesión")
                                .bold()
                                .frame(width: 230, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(red: 255/255, green: 217/255, blue: 245/255))
                                )
                                .foregroundStyle(.black)
                        }
                        .padding(.top)
                        
                        // Enlace al registro
                        NavigationLink(destination: SignUpView()) {
                            Text("¿Todavía no tienes una cuenta? Regístrate")
                                .bold()
                                .foregroundStyle(.black)
                                .font(.caption2)
                        }
                    }
                    .frame(width: 230)
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    LogIn()
}

// Extensión para los placeholders en los campos de texto
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

// Campo de texto personalizado
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .bold()
                }
                TextField("", text: $text)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
            }
            Rectangle()
                .frame(width: 230, height: 1)
                .foregroundStyle(.black)
        }
    }
}


// Campo de contraseña personalizado
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .bold()
                }
                SecureField("", text: $text)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
            }
            Rectangle()
                .frame(width: 230, height: 1)
                .foregroundStyle(.black)
        }
    }
}
