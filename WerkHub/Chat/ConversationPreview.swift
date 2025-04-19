//
//  ConversationPreview.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 9/5/25.
//

import Foundation

// Modelo que representa una conversación en la lista de chats
struct ConversationPreview: Identifiable {
    let id = UUID()          // Identificador único automático
    let name: String         // Nombre del contacto o conversación
    let lastMessage: String  // Último mensaje enviado o recibido
    let time: String         // Hora del último mensaje
    let unread: Bool         // Indica si hay mensajes sin leer
}

// Modelo que representa un mensaje dentro de una conversación
struct Message: Identifiable {
    let id: Int                  // Identificador único del mensaje
    let text: String             // Contenido del mensaje
    let isFromCurrentUser: Bool  // Indica si el mensaje fue enviado por el usuario actual
}
