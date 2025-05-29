//
//  Register.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 20/1/25.
//

import SwiftUI
import FirebaseFirestore

// Vista de registro de nuevos usuarios
struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var accountType = "Artista"
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    @AppStorage("isAuthenticated") private var isAuthenticated = false
    
    let accountTypes = ["Artista", "Promotor"]
    
    var body: some View {
        NavigationStack {
            if isAuthenticated {
                MainView()
            } else {
                ZStack {
                    // Background
                    Color(red: 255/255, green: 246/255, blue: 253/255)
                        .ignoresSafeArea()
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(Color(red: 255/255, green: 217/255, blue: 245/255))
                        .frame(width: 1000, height: 400)
                        .rotationEffect(.degrees(135))
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(.white)
                        .frame(width: 300, height: 550)
                    
                    // Form content
                    VStack(spacing: 20) {
                        Image("WerkHub_Text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        CustomTextField(placeholder: "Email", text: $email)
                        CustomSecureField(placeholder: "Contraseña", text: $password)
                        CustomSecureField(placeholder: "Repetir contraseña", text: $confirmPassword)
                        
                        // Password requirements
                        VStack(alignment: .leading, spacing: 5) {
                            Text("• Mínimo 8 caracteres")
                                .foregroundColor(password.count >= 8 ? .green : .red)
                                .font(.caption)
                            Text("• Al menos una letra mayúscula")
                                .foregroundColor(password.range(of: "[A-Z]", options: .regularExpression) != nil ? .green : .red)
                                .font(.caption)
                            Text("• Al menos un número")
                                .foregroundColor(password.range(of: "[0-9]", options: .regularExpression) != nil ? .green : .red)
                                .font(.caption)
                            Text("• Al menos un carácter especial")
                                .foregroundColor(password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil ? .green : .red)
                                .font(.caption)
                        }
                        
                        // Account type picker
                        Picker("Tipo de cuenta", selection: $accountType) {
                            ForEach(accountTypes, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 230, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .foregroundStyle(.black)
                        
                        // Register button
                        Button {
                            if password != confirmPassword {
                                errorMessage = "Las contraseñas no coinciden"
                            } else if !validatePassword(password) {
                                errorMessage = "La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un carácter especial."
                            } else if !isValidEmail(email) {
                                errorMessage = "Formato de correo inválido"
                            } else {
                                signUp()
                            }
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .tint(.black)
                            } else {
                                Text("Registrarse")
                                    .bold()
                            }
                        }
                        .frame(width: 230, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(red: 255/255, green: 217/255, blue: 245/255))
                        )
                        .foregroundStyle(.black)
                        .disabled(isLoading)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 5)
                        }
                    }
                    .frame(width: 230)
                }
            }
        }
    }
    
    func signUp() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                // 1. Create auth user
                let returnedUserData = try await AuthenticationManager.shared.createUser(
                    email: email,
                    password: password
                )
                let uid = returnedUserData.uid
                
                // 2. Create user document in Firestore
                let db = Firestore.firestore()
                try await db.collection("users").document(uid).setData([
                    "uid": uid,
                    "email": email,
                    "accountType": accountType,
                    "bio": "",
                    "profileImageUrl": "",
                    "createdAt": Timestamp(date: Date()),
                    "updatedAt": Timestamp(date: Date())
                ])
                
                print("User created successfully with UID: \(uid)")
                isAuthenticated = true
                
            } catch {
                print("Registration error: \(error)")
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}

// Password validation function
func validatePassword(_ password: String) -> Bool {
    let minLength = password.count >= 8
    let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
    let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
    let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
    let hasSpecialCharacter = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
    
    return minLength && hasUppercase && hasLowercase && hasNumber && hasSpecialCharacter
}

// Email validation function
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: email)
}


#Preview {
    SignUpView()
}
