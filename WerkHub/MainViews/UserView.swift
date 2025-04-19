//
//  UserView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 14/2/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Vista que muestra el perfil del usuario autenticado
struct UserView: View {
    
    // Datos del usuario obtenidos desde Firestore
    @State private var userData: UserData?
    
    // Estado para mostrar la vista de edición del perfil
    @State private var isEditing = false
    
    // Estados para controlar errores
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Controla si el usuario está autenticado o no (viene del exterior)
    @Binding var isAuthenticated: Bool
    
    // Inicializador para pasar el binding desde otra vista
    init(isAuthenticated: Binding<Bool>) {
        self._isAuthenticated = isAuthenticated
    }
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack(spacing: 20) {
                    
                    // Título de la vista
                    HStack {
                        Text("Mi Perfil")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            // Imagen de perfil (con lógica incluida más abajo)
                            profileImage
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(radius: 5)
                                .padding(.top, 10)
                            
                            // Tipo de cuenta del usuario (por ejemplo, "Artista")
                            if let accountType = userData?.accountType {
                                Text(accountType)
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.9))
                                    .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                                    .cornerRadius(20)
                            }
                            
                            // Biografía del usuario o mensaje si no hay texto
                            if let bio = userData?.bio, !bio.isEmpty {
                                Text(bio)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.9))
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                            } else {
                                Text("Añade una biografía")
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.9))
                                    .foregroundColor(.gray)
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                            }
                            
                            Spacer()
                            
                            // Botón para editar el perfil
                            Button(action: { isEditing = true }) {
                                Text("Editar Perfil")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color(red: 225/255, green: 71/255, blue: 126/255))
                                    .cornerRadius(25)
                            }
                            .padding(.vertical)
                            
                            // Botón para cerrar sesión
                            Button(action: logout) {
                                Text("Cerrar sesión")
                                    .bold()
                                    .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                                    .frame(width: 200, height: 50)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(25)
                            }
                            .padding(.bottom, 30)
                        }
                    }
                }
                .navigationBarHidden(true)
                
                // Vista para editar el perfil (modal)
                .sheet(isPresented: $isEditing) {
                    if let userData = userData {
                        EditProfileView(userData: userData) { updatedData in
                            self.userData = updatedData
                        }
                    }
                }
                
                // Alerta en caso de error
                .alert("Error", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }
                
                // Carga de datos al entrar en la vista
                .task {
                    await fetchUserData()
                }
            }
        }
    }
    
    // Muestra la imagen de perfil del usuario o un ícono por defecto
    private var profileImage: some View {
        Group {
            if let imageUrl = userData?.profileImageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        defaultProfileImage
                    @unknown default:
                        defaultProfileImage
                    }
                }
            } else {
                defaultProfileImage
            }
        }
        .frame(width: 150, height: 150)
        .clipShape(Circle())
    }
    
    // Imagen por defecto si el usuario no tiene foto de perfil
    private var defaultProfileImage: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
    }
    
    // Carga los datos del usuario desde Firestore (o los crea si no existen)
    private func fetchUserData() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No has iniciado sesión"
            showError = true
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        do {
            let document = try await userRef.getDocument()
            if document.exists {
                // Si ya existe, se recuperan los datos
                userData = try document.data(as: UserData.self)
            } else {
                // Si no existe, se crea con valores por defecto
                guard let currentUser = Auth.auth().currentUser else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])
                }
                
                let newUserData = UserData(
                    uid: userId,
                    accountType: "Artista",
                    bio: "",
                    email: currentUser.email ?? "",
                    profileImageUrl: ""
                )
                
                // Se guarda el nuevo documento en Firestore
                try userRef.setData(from: newUserData)
                userData = newUserData
            }
        } catch {
            errorMessage = "Error al cargar/crear los datos: \(error.localizedDescription)"
            showError = true
        }
    }
    
    // Cierra la sesión del usuario actual
    private func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            errorMessage = "Error al cerrar sesión: \(error.localizedDescription)"
            showError = true
        }
    }
}

#Preview {
    UserView(isAuthenticated: .constant(true))
}
