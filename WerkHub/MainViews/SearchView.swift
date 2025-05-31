//
//  SearchView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 14/2/25.
//

// SearchView.swift
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "Todos"
    @State private var accountType: String? = nil
    @State private var isLoading = true
    
    var eventCategories: [String] {
        let categories = Set(allEvents.map { $0.category })
        return ["Todos"] + Array(categories).sorted()
    }
    
    var artistCategories: [String] {
        let styles = Set(artists.map { $0.style })
        return ["Todos"] + Array(styles).sorted()
    }
    
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
    
    let artists: [Artist] = [
        Artist(id: "1", name: "Sasha Colby", imageUrl: "https://example.com/sasha.jpg", bio: "Artista drag reconocida internacionalmente por su talento y carisma.", style: "Glamour"),
        Artist(id: "2", name: "Monet X Change", imageUrl: "https://example.com/monet.jpg", bio: "Drag queen y comediante que combina humor con arte visual.", style: "Comedia"),
        Artist(id: "3", name: "Bob the Drag Queen", imageUrl: "https://example.com/bob.jpg", bio: "Activista y performer, conocida por su personalidad arrolladora.", style: "Comedia"),
        Artist(id: "4", name: "Krystal Versace", imageUrl: "https://example.com/krystal.jpg", bio: "Joven promesa del drag con un estilo visual impactante.", style: "Fashion"),
        Artist(id: "5", name: "Jujubee", imageUrl: "https://example.com/jujubee.jpg", bio: "Artista con gran trayectoria en el mundo del drag y la música.", style: "Versátil"),
        Artist(id: "6", name: "Kim Jayne", imageUrl: "https://example.com/kim.jpg", bio: "Performer drag con espectáculos llenos de emoción.", style: "Drama"),
        Artist(id: "7", name: "Rebeca Santa María", imageUrl: "https://example.com/rebeca.jpg", bio: "Artista que fusiona folclore y cultura drag en shows únicos.", style: "Folclore"),
        Artist(id: "8", name: "Ilse Alamierda", imageUrl: "https://example.com/ilse.jpg", bio: "Explora el drag desde lo conceptual y experimental.", style: "Conceptual"),
        Artist(id: "9", name: "Chuleta de Cerda", imageUrl: "https://example.com/chuleta.jpg", bio: "Humor, irreverencia y shows memorables.", style: "Comedia"),
        Artist(id: "10", name: "Angelina Moore", imageUrl: "https://example.com/angelina.jpg", bio: "Drag queen sofisticada con presencia escénica única.", style: "Elegancia"),
        Artist(id: "11", name: "La Bella Vampi", imageUrl: "https://example.com/vampi.jpg", bio: "Artista con un toque oscuro y teatral.", style: "Gothic"),
        Artist(id: "12", name: "Le Coco", imageUrl: "https://example.com/lecoco.jpg", bio: "Estética retro y actitud desenfadada en el escenario.", style: "Retro"),
        Artist(id: "13", name: "Chloe Vittu", imageUrl: "https://example.com/chloe.jpg", bio: "Fusiona baile y lip-sync en espectáculos cautivadores.", style: "Dance"),
        Artist(id: "14", name: "Lassie Verguenza", imageUrl: "https://example.com/lassie.jpg", bio: "Actuaciones divertidas que sacan sonrisas.", style: "Comedia")
    ]
    
    var filteredEvents: [Event] {
        allEvents.filter { event in
            (selectedCategory == "Todos" || event.category == selectedCategory) &&
            (searchText.isEmpty || event.name.lowercased().contains(searchText.lowercased()))
        }
    }
    
    var filteredArtists: [Artist] {
        artists.filter { artist in
            (selectedCategory == "Todos" || artist.style == selectedCategory) &&
            (searchText.isEmpty || artist.name.lowercased().contains(searchText.lowercased()))
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255).ignoresSafeArea()
            
            if isLoading {
                ProgressView("Cargando...")
            } else {
                VStack(spacing: 20) {
                    HStack {
                        Text("Buscar")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    TextField("Buscar por nombre...", text: $searchText)
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Filtros por categoría según el tipo de usuario
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            let categories = accountType == "Artista" ? eventCategories : artistCategories
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
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            if accountType == "Artista" {
                                Text("Eventos")
                                    .font(.headline)
                                    .padding(.horizontal)
                                ForEach(filteredEvents) { event in
                                    EventCard(event: event)
                                }
                            } else if accountType == "Promotor" {
                                Text("Artistas")
                                    .font(.headline)
                                    .padding(.horizontal)
                                ForEach(filteredArtists) { artist in
                                    ArtistResultCard(artist: artist)
                                }
                            } else {
                                Text("No hay resultados disponibles.")
                                    .padding()
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear {
            fetchAccountType()
        }
    }
    
    func fetchAccountType() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                accountType = document.get("accountType") as? String
            }
            isLoading = false
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

#Preview {
    SearchView()
}
