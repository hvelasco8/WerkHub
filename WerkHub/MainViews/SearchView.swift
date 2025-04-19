//
//  SearchView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 14/2/25.
//

import SwiftUI

// Vista que permite buscar eventos y filtrarlos por categoría
struct SearchView: View {
    
    // Texto de búsqueda introducido por el usuario
    @State private var searchText: String = ""
    
    // Categoría actualmente seleccionada
    @State private var selectedCategory: String = "Todos"
    
    // Categorías disponibles para filtrar eventos
    let categories = ["Todos", "Drag", "Queer", "Fiesta", "Performance"]
    
    // Lista de eventos simulados
    let allEvents: [Event] = [
        Event(name: "La Liada", category: "Drag", date: "Sábado 25 Mayo", description: "Una de las fiestas drag más vibrantes de Madrid."),
        Event(name: "This Is Drag", category: "Performance", date: "Jueves 30 Mayo", description: "Show con artistas invitadas internacionales."),
        Event(name: "Roar Party", category: "Queer", date: "Viernes 31 Mayo", description: "Fiesta queer con DJ y ambientazo."),
        Event(name: "Ballroom Nights", category: "Performance", date: "Miércoles 5 Junio", description: "Noche de voguing, runway y cultura ballroom."),
        Event(name: "Glitter Rave", category: "Fiesta", date: "Sábado 8 Junio", description: "Rave con performances y glitter por todas partes."),
        Event(name: "Mood Pop Club", category: "Fiesta", date: "Viernes 7 Junio", description: "Pop, visuales y drag shows en un ambiente inclusivo."),
        Event(name: "Independance Club", category: "Fiesta", date: "Sábado 15 Junio", description: "Sesión queer alternando electrónica y performance."),
        Event(name: "Studio 54 Night", category: "Queer", date: "Viernes 21 Junio", description: "Tributo a los años 70 con looks, plumas y drag glam."),
        Event(name: "Ultrapop Madrid", category: "Drag", date: "Sábado 22 Junio", description: "Pop + shows drag en una pista sin prejuicios."),
        Event(name: "Tanga Party", category: "Fiesta", date: "Domingo 23 Junio", description: "Una de las fiestas queer más grandes de España."),
        Event(name: "Boite Mix", category: "Queer", date: "Viernes 28 Junio", description: "Club ecléctico con DJ sets, performers y ambientazo."),
        Event(name: "Bitch Party", category: "Performance", date: "Sábado 29 Junio", description: "Evento mensual con cabaret queer y artistas drag."),
        Event(name: "Maricoin Sessions", category: "Queer", date: "Domingo 30 Junio", description: "Activismo, arte y música drag en una misma sala."),
        Event(name: "Dark Pop Fever", category: "Fiesta", date: "Sábado 6 Julio", description: "Pop alternativo con toques electrónicos y shows visuales."),
        Event(name: "Fiesta Flower Trap", category: "Drag", date: "Sábado 13 Julio", description: "Fusión entre trap, reggaetón y shows travestis.")
    ]
    
    // Filtra los eventos según el texto y la categoría seleccionada
    var filteredEvents: [Event] {
        allEvents.filter { event in
            (selectedCategory == "Todos" || event.category == selectedCategory) &&
            (searchText.isEmpty || event.name.lowercased().contains(searchText.lowercased()))
        }
    }
    
    var body: some View {
        ZStack {
            // Color de fondo de la vista
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // Título de la sección
                HStack {
                    Text("Buscar Eventos")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Campo de búsqueda
                TextField("Buscar por nombre...", text: $searchText)
                    .padding(12)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Selector de categorías
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                                .font(.caption)
                                .bold()
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    selectedCategory == category ?
                                    Color(red: 225/255, green: 71/255, blue: 126/255) :
                                        Color.white.opacity(0.9)
                                )
                                .foregroundColor(selectedCategory == category ? .white : .black)
                                .cornerRadius(20)
                                .onTapGesture {
                                    selectedCategory = category
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Resultados de la búsqueda filtrada
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredEvents) { event in
                            EventCard(event: event)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
    }
}

// Modelo de evento
struct Event: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let date: String
    let description: String
}

// Vista que representa una tarjeta de evento
struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.headline)
                .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
            
            Text(event.date)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(event.description)
                .font(.caption)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(Color.white.opacity(0.95))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SearchView()
}
