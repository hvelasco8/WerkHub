//
//  Register.swift
//  WerkHub
//
//  Created by Héctor Velasco on 20/1/25.
//

import SwiftUI

struct SignUpView: View {
    // Variables para el registro de usuario
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var accountType = "Artista"
    @State private var errorMessage: String = ""
    
    // Tipos de cuenta
    let accountTypes = ["Artista", "Promotor"]
    
    func signUp(){
        Task {
            do{
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            }
            catch{
                print("Error: \(error)")
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            // Fondo
            Color(red: 255/255, green: 246/255, blue: 253/255)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(Color(red: 255/255, green: 217/255, blue: 245/255))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -320)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.white)
                .frame(width: 300, height: 550)
            
            //Contenido
            VStack(spacing: 20) {
                
                //Logo
                Image("WerkHub_Text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                // Campos personalizados - Definidos en ContentView
                CustomTextField(placeholder: "Email", text: $email)
                CustomSecureField(placeholder: "Contraseña", text: $password)
                CustomSecureField(placeholder: "Repetir contraseña", text: $confirmPassword)
                
                // Reglas para la validación de la contraseña
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
                
                // Selector tipo de cuenta
                Picker("Tipo de cuenta", selection: $accountType) {
                    ForEach(accountTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 230, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black, lineWidth: 1)
                )
                .foregroundStyle(.black)
                
                // Botón de registro y validación
                Button {
                    if password != confirmPassword {
                        errorMessage = "Las contraseñas no coinciden"
                    } else if !validatePassword(password) {
                        errorMessage = "La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un carácter especial."
                    } else if !isValidEmail(email) {
                        errorMessage = "Formato de correo inválido"
                    } else {
                        print("Registro exitoso como \(accountType)")
                        // Registro del usuario en Firebase
                        signUp()
                    }
                } label: {
                    Text("Registrarse")
                        .bold()
                        .frame(width: 230, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(red: 255/255, green: 217/255, blue: 245/255))
                        )
                        .foregroundStyle(.black)
                }
                
                // Mensaje de error, en el caso que exista
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

#Preview {
    SignUpView()
}

// Función de retorno boolean para la validación de la contraseña
func validatePassword(_ password: String) -> Bool {
    let minLength = password.count >= 8
    let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
    let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
    let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
    let hasSpecialCharacter = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
    
    return minLength && hasUppercase && hasLowercase && hasNumber && hasSpecialCharacter
}

// Función de retorno boolean para la validación del email
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: email)
}
