//
//  ImagePicker.swift
//  WerkHub
//
//  Created by Héctor Velasco on 19/4/25.
//

import SwiftUI
import UIKit

// Componente que permite seleccionar una imagen desde la galería del dispositivo
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?                      // Imagen seleccionada que se envía a la vista principal
    @Environment(\.dismiss) var dismiss               // Permite cerrar el selector de imagen
    
    // Crea un coordinador que se encargará de manejar los eventos del picker
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Crea e inicializa el UIImagePickerController (galería del sistema)
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator          // Delegado que escucha la selección
        picker.allowsEditing = true                    // Permite editar la imagen (recorte, zoom)
        return picker
    }
    
    // No se necesita actualizar el controlador en este caso
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Clase interna que actúa como puente entre UIKit y SwiftUI
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // Método llamado cuando el usuario selecciona una imagen o cancela
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Intenta obtener la imagen editada primero, y si no, la original
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss() // Cierra la vista del picker después de seleccionar
        }
    }
}
