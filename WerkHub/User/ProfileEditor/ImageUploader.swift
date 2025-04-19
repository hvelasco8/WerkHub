//
//  ImageUploader.swift
//  WerkHub
//
//  Created by Héctor Velasco on 21/5/25.
//

import UIKit
import FirebaseStorage

// Encapsula la lógica para subir imágenes a Firebase Storage
struct ImageUploader {
    
    // Función que sube una imagen de perfil y devuelve su URL pública
    static func uploadProfileImage(_ image: UIImage, for userId: String) async throws -> String {
        // Se genera un nombre único para la imagen usando UUID
        let imageName = "\(UUID().uuidString).jpg"
        
        // Se construye la ruta de almacenamiento dentro del bucket de Firebase
        let storageRef = Storage.storage().reference()
            .child("profile_images")
            .child(userId)
            .child(imageName)
        
        // Se convierte la imagen a datos JPEG comprimidos
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            // Si falla la conversión, se lanza un error personalizado
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se pudo convertir la imagen"])
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Se suben los datos de imagen al almacenamiento en Firebase
        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        
        // Una vez subida, se obtiene la URL de descarga de la imagen
        let url = try await storageRef.downloadURL()
        return url.absoluteString  // Se devuelve la URL como String
    }
}
