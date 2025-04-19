//
//  MessagesView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 9/5/25.
//

import SwiftUI

// Vista que muestra una conversación entre dos usuarios
struct MessagesView: View {
    let partnerName: String           // Nombre del contacto con el que se conversa
    let messages: [Message]           // Lista de mensajes de la conversación
    
    @State private var newMessage = ""  // Mensaje nuevo que el usuario está escribiendo
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            VStack {
                
                // Encabezado con el nombre del contacto
                HStack {
                    Text(partnerName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                
                // Área donde se muestran los mensajes
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isFromCurrentUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color(red: 225/255, green: 71/255, blue: 126/255))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.white.opacity(0.8))
                                        .foregroundColor(.black)
                                        .cornerRadius(15)
                                        .frame(maxWidth: 250, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                
                // Campo para escribir y enviar un nuevo mensaje
                HStack {
                    TextField("Escribe un mensaje...", text: $newMessage)
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                    
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color(red: 225/255, green: 71/255, blue: 126/255))
                        .clipShape(Circle())
                }
                .padding()
            }
        }
    }
}
