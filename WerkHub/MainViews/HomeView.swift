//
//  ChatView.swift
//  WerkHub
//
//  Creado por Héctor Velasco el 14/2/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var accountType: String? = nil
    @State private var isLoading = true
    
    // Lista de Promotores
    let promoters: [Promoter] = [
        Promoter(id: "1", name: "La Liada", imageUrl: "https://example.com/laliada.jpg", bio: "Fiesta drag alternativa con DJ, shows y performances underground.", eventsHosted: 25, rating: 4.8),
        Promoter(id: "2", name: "This Is Drag", imageUrl: "https://example.com/thisisdrag.jpg", bio: "El show drag más internacional de Madrid con Artistas invitadas.", eventsHosted: 40, rating: 4.9),
        Promoter(id: "3", name: "Roar Party", imageUrl: "https://example.com/roarparty.jpg", bio: "Eventos queer de música y cultura drag en salas icónicas de la ciudad.", eventsHosted: 30, rating: 4.6),
        Promoter(id: "4", name: "Maricoin", imageUrl: "https://example.com/maricoin.jpg", bio: "Evento que une activismo, arte y fiesta para la comunidad LGTBIQ+.", eventsHosted: 12, rating: 4.7),
        Promoter(id: "5", name: "LL Show", imageUrl: "https://example.com/llshow.jpg", bio: "Experiencia drag deluxe con actuaciones coreografiadas en salas selectas.", eventsHosted: 18, rating: 4.5),
        Promoter(id: "6", name: "Drag is Burning", imageUrl: "https://example.com/dragisburning.jpg", bio: "Homenaje a la cultura ballroom y drag underground.", eventsHosted: 20, rating: 4.9),
        Promoter(id: "7", name: "Mood Pop Club", imageUrl: "https://example.com/moodpop.jpg", bio: "Club con visuales pop, DJ queer y shows drag cada viernes.", eventsHosted: 18, rating: 4.7),
        Promoter(id: "8", name: "Independance Club", imageUrl: "https://example.com/independance.jpg", bio: "Sesiones queer donde se mezcla electrónica y cultura drag alternativa.", eventsHosted: 22, rating: 4.4),
        Promoter(id: "9", name: "Tanga Party", imageUrl: "https://example.com/tangaparty.jpg", bio: "Macrofiesta con coreos, drag queens, gogós y varios escenarios.", eventsHosted: 50, rating: 4.8),
        Promoter(id: "10", name: "Ultrapop", imageUrl: "https://example.com/ultrapop.jpg", bio: "Pop sin complejos, ambiente libre y drags residentes.", eventsHosted: 35, rating: 4.5),
        Promoter(id: "11", name: "Boite Mix", imageUrl: "https://example.com/boite.jpg", bio: "Sala ecléctica con ambientazo queer y sesiones con performance.", eventsHosted: 15, rating: 4.3),
        Promoter(id: "12", name: "Bitch Party", imageUrl: "https://example.com/bitchparty.jpg", bio: "Cabaret drag alternativo con Artistas queer y espectáculos únicos.", eventsHosted: 12, rating: 4.6)
    ]
    
    // Lista de Artistas
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
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Cargando...")
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text(accountType == "Artista" ? "Promotores" : "Artistas")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            if accountType == "Artista" {
                                ForEach(promoters) { promoter in
                                    NavigationLink(destination: PromoterProfileView(promoter: promoter)) {
                                        PromoterCard(promoter: promoter)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            } else if accountType == "Promotor" {
                                ForEach(artists) { artist in
                                    NavigationLink(destination: ArtistProfileView(artist: artist)) {
                                        ArtistCard(artist: artist)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            fetchAccountType()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                fetchAccountType()
            }
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

// Vista previa para SwiftUI
#Preview {
    HomeView()
}
