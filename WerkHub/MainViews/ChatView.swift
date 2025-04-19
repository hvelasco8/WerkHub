//
//  ChatView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 14/2/25.
//

import SwiftUI

// Vista que muestra la lista de conversaciones del usuario
struct ChatView: View {
    
    // Lista de conversaciones simuladas
    let conversations = [
        ConversationPreview(name: "This Is Drag", lastMessage: "Perfecto, quedo atento", time: "10:30 AM", unread: false),
        ConversationPreview(name: "La Liada", lastMessage: "Te envío los detalles del evento", time: "Ayer", unread: true),
        ConversationPreview(name: "Equipo WerkHub", lastMessage: "Si tienes cualquier duda sobre...", time: "Lunes", unread: false)
    ]
    
    // Diccionario con los mensajes de cada conversación
    let messagesByContact: [String: [Message]] = [
        "This Is Drag": [
            Message(id: 1, text: "Hola, ¿estás disponible para un evento el sábado 25?", isFromCurrentUser: false),
            Message(id: 2, text: "¡Hola! Sí, me encantaría participar 😊", isFromCurrentUser: true),
            Message(id: 3, text: "Genial, te paso el contrato en un rato", isFromCurrentUser: false),
            Message(id: 4, text: "Perfecto, quedo atento", isFromCurrentUser: true)
        ],
        "La Liada": [
            Message(id: 1, text: "¿Todo listo para el sábado?", isFromCurrentUser: false),
            Message(id: 2, text: "¡Sí! Gracias por contar conmigo 😄", isFromCurrentUser: true),
            Message(id: 3, text: "Te envío los detalles del evento", isFromCurrentUser: false)
        ],
        "Equipo WerkHub": [
            Message(id: 1, text: "Bienvenido a la app!", isFromCurrentUser: false),
            Message(id: 2, text: "Si tienes cualquier duda sobre su funcionamiento, estaremos encantados de ayudar ✨", isFromCurrentUser: false)
        ]
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255/255, green: 217/255, blue: 245/255)
                    .ignoresSafeArea()
                
                VStack {
                    // Título de la vista
                    HStack {
                        Text("Chats")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Lista de conversaciones
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(conversations) { chat in
                                // Al tocar una conversación, se navega a la vista de mensajes
                                NavigationLink(
                                    destination: MessagesView(
                                        partnerName: chat.name,
                                        messages: messagesByContact[chat.name] ?? []
                                    )
                                ) {
                                    ConversationRow(chat: chat)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
