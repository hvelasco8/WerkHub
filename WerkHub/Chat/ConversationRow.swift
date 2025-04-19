//
//  ConversationRow.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 9/5/25.
//

import SwiftUI

// Vista que muestra una fila individual dentro de la lista de conversaciones
struct ConversationRow: View {
    let chat: ConversationPreview  // Datos del chat a mostrar (nombre, último mensaje, etc.)
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Avatar circular con la inicial del nombre del contacto
            Circle()
                .fill(Color(red: 225/255, green: 71/255, blue: 126/255))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(chat.name.prefix(1))
                        .foregroundColor(.white)
                        .font(.title3)
                )
            
            // Información principal del chat (nombre, hora y último mensaje)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chat.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(chat.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Último mensaje, truncado si es muy largo
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    .lineLimit(1)
            }
            
            // Indicador de mensaje no leído (pequeño círculo a la derecha)
            if chat.unread {
                Circle()
                    .fill(Color(red: 225/255, green: 71/255, blue: 126/255))
                    .frame(width: 10, height: 10)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
    }
}
