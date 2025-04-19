//
//  EditProfileView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 21/5/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Vista que permite al usuario editar su perfil
struct EditProfileView: View {
    @State var userData: UserData                   // Datos actuales del usuario
    var onSave: (UserData) -> Void                  // Función callback que se ejecuta al guardar cambios
    
    @Environment(\.dismiss) var dismiss             // Permite cerrar la vista al pulsar "Cancelar" o guardar
    
    // Variables de estado para la imagen, carga, errores...
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    // Barra superior con botones de cancelar y guardar
                    HStack {
                        Button("Cancelar") { dismiss() }
                            .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                        
                        Spacer()
                        
                        Text("Editar Perfil")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button("Guardar") {
                            Task { await saveProfile() }  // Acción asíncrona al guardar
                        }
                        .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                        .disabled(isLoading)  // Desactiva botón mientras guarda
                    }
                    .padding()
                    
                    Form {
                        // Imagen de perfil editable
                        Section {
                            HStack {
                                Spacer()
                                editableProfileImage
                                Spacer()
                            }
                            .padding(.vertical)
                            .listRowBackground(Color.clear)
                        }
                        
                        // Selector de tipo de cuenta
                        Section("Tipo de Cuenta") {
                            Picker("Tipo de Cuenta", selection: $userData.accountType) {
                                Text("Artista").tag("Artista")
                                Text("Promotor").tag("Promotor")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .listRowBackground(Color.white.opacity(0.9))
                        }
                        
                        // Campo para editar la biografía
                        Section("Biografía") {
                            TextEditor(text: $userData.bio)
                                .frame(minHeight: 100)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .navigationBarHidden(true)
                
                // Picker para seleccionar nueva imagen de perfil desde galería
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                
                // Alerta en caso de error al guardar
                .alert("Error", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }
            }
        }
    }
    
    // Vista de la imagen de perfil editable
    private var editableProfileImage: some View {
        Button {
            showingImagePicker = true  // Al pulsar, muestra el selector de imagen
        } label: {
            Group {
                if let image = inputImage {
                    // Si hay una nueva imagen seleccionada, se muestra
                    Image(uiImage: image).resizable().scaledToFill()
                } else if !userData.profileImageUrl.isEmpty {
                    // Si ya hay imagen subida, se carga desde la URL
                    AsyncImage(url: URL(string: userData.profileImageUrl)) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        default: defaultProfileImage
                        }
                    }
                } else {
                    // Si no hay imagen previa, se muestra una imagen por defecto
                    defaultProfileImage
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(
                // Ícono de lápiz superpuesto para indicar que se puede editar
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                    .background(Color.white.clipShape(Circle()))
                    .offset(x: 40, y: 40)
            )
        }
    }
    
    // Imagen por defecto en caso de no haber imagen de perfil
    private var defaultProfileImage: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
    }
    
    // Función que guarda los cambios del perfil en Firestore y sube imagen si es nueva
    private func saveProfile() async {
        isLoading = true
        
        // Si hay una imagen nueva seleccionada, se sube a Firebase Storage
        if let inputImage = inputImage {
            if let url = try? await ImageUploader.uploadProfileImage(inputImage, for: userData.uid) {
                userData.profileImageUrl = url
            } else {
                errorMessage = "Error al subir la imagen"
                showError = true
                isLoading = false
                return
            }
        }
        
        // Se actualiza el documento del usuario en Firestore con los nuevos datos
        do {
            try Firestore.firestore().collection("users").document(userData.uid).setData(from: userData)
            onSave(userData)  // Se pasa el nuevo usuario a la vista anterior
            dismiss()         // Se cierra la vista
        } catch {
            errorMessage = "Error al guardar: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
}
