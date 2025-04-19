//
//  ContentView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 16/1/25.
//

import SwiftUI
import FirebaseAuth

// Vista para el inicio de sesión
struct LogIn: View {
    
    // Variable que indica si el usuario ha iniciado sesión correctamente
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    // Campos del formulario
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    // Función que intenta iniciar sesión usando Firebase
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
            // Si el usuario ya está autenticado, se muestra la vista principal
            if isAuthenticated {
                MainView()
            } else {
                ZStack {
                    Color(red: 255/255, green: 246/255, blue: 253/255)
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(Color(red: 255/255, green: 217/255, blue: 245/255))
                        .frame(width: 1000, height: 400)
                        .rotationEffect(.degrees(135))
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 450)
                    
                    // Contenido del formulario
                    VStack(spacing: 20) {
                        Image("WerkHub_Text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        CustomTextField(placeholder: "Email", text: $email)
                        CustomSecureField(placeholder: "Contraseña", text: $password)
                        
                        // Mensaje de error si el inicio de sesión falla
                        if errorMessage != nil {
                            Text("No se ha encontrado una cuenta con ese email y/o contraseña.")
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 10)
                        }
                        
                        // Botón para iniciar sesión
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
                        
                        // Enlace a la vista de registro
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

// Extensión para mostrar un placeholder cuando el campo está vacío
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

// Campo de texto personalizado para email u otros datos
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
