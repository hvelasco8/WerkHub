import SwiftUI

struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
}

struct HomeView: View {
    // Lista de eventos drag reales de Madrid
    let promoters: [Promoter] = [
        Promoter(id: "1", name: "La Liada", imageUrl: "https://example.com/laliada.jpg", bio: "Fiesta drag alternativa con DJ, shows y performances underground.", eventsHosted: 25, rating: 4.8),
        Promoter(id: "2", name: "This Is Drag", imageUrl: "https://example.com/thisisdrag.jpg", bio: "El show drag más internacional de Madrid con artistas invitadas.", eventsHosted: 40, rating: 4.9),
        Promoter(id: "3", name: "Roar Party", imageUrl: "https://example.com/roarparty.jpg", bio: "Eventos queer de música y cultura drag en salas icónicas de la ciudad.", eventsHosted: 30, rating: 4.6),
        Promoter(id: "4", name: "Maricoin", imageUrl: "https://example.com/maricoin.jpg", bio: "Evento que une activismo, arte y fiesta para la comunidad LGTBIQ+.", eventsHosted: 12, rating: 4.7),
        Promoter(id: "5", name: "LL Show", imageUrl: "https://example.com/llshow.jpg", bio: "Experiencia drag deluxe con actuaciones coreografiadas en salas selectas.", eventsHosted: 18, rating: 4.5),
        Promoter(id: "6", name: "Drag is Burning", imageUrl: "https://example.com/dragisburning.jpg", bio: "Homenaje a la cultura ballroom y drag underground.", eventsHosted: 20, rating: 4.9),
        Promoter(id: "7", name: "Mood Pop Club", imageUrl: "https://example.com/moodpop.jpg", bio: "Club con visuales pop, DJ queer y shows drag cada viernes.", eventsHosted: 18, rating: 4.7),
        Promoter(id: "8", name: "Independance Club", imageUrl: "https://example.com/independance.jpg", bio: "Sesiones queer donde se mezcla electrónica y cultura drag alternativa.", eventsHosted: 22, rating: 4.4),
        Promoter(id: "9", name: "Tanga Party", imageUrl: "https://example.com/tangaparty.jpg", bio: "Macrofiesta con coreos, drag queens, gogós y varios escenarios.", eventsHosted: 50, rating: 4.8),
        Promoter(id: "10", name: "Ultrapop", imageUrl: "https://example.com/ultrapop.jpg", bio: "Pop sin complejos, ambiente libre y drags residentes.", eventsHosted: 35, rating: 4.5),
        Promoter(id: "11", name: "Boite Mix", imageUrl: "https://example.com/boite.jpg", bio: "Sala ecléctica con ambientazo queer y sesiones con performance.", eventsHosted: 15, rating: 4.3),
        Promoter(id: "12", name: "Bitch Party", imageUrl: "https://example.com/bitchparty.jpg", bio: "Cabaret drag alternativo con artistas queer y espectáculos únicos.", eventsHosted: 12, rating: 4.6)
    ]
    
    // Custom background color
    let customBackgroundColor = Color(red: 255/255, green: 217/255, blue: 245/255)
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Título de la pantalla
                    HStack {
                        Text("Promotores")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Cuadrícula con tarjetas de eventos
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(promoters) { promoter in
                            // Cada tarjeta redirige a su perfil
                            NavigationLink(destination: PromoterProfileView(promoter: promoter)) {
                                PromoterCard(promoter: promoter)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .navigationBarHidden(true)
    }
}

// Tarjeta visual de cada promotor/evento en la cuadrícula
struct PromoterCard: View {
    let promoter: Promoter
    
    var body: some View {
        VStack(spacing: 8) {
            // Imagen del evento (o ícono si falla)
            AsyncImage(url: URL(string: promoter.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                } else {
                    ProgressView()
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
            .shadow(radius: 5)
            
            // Nombre del evento
            Text(promoter.name)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

// Vista de perfil de cada promotor/evento
struct PromoterProfileView: View {
    let promoter: Promoter
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Imagen principal del perfil
                    AsyncImage(url: URL(string: promoter.imageUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 20)
                    
                    // Nombre del evento
                    Text(promoter.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    // Métricas del evento: cantidad de eventos y puntuación
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(promoter.eventsHosted)")
                                .font(.title3)
                                .bold()
                            Text("Eventos")
                                .font(.caption)
                        }
                        Divider()
                            .frame(height: 40)
                        VStack {
                            Text(String(format: "%.2f", promoter.rating))
                                .font(.title3)
                                .bold()
                            Text("Rating")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(15)
                    
                    // Descripción/bio del evento
                    Text(promoter.bio)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
                    // Botón de acción (puede usarse para contactar o reservar)
                    Button(action: {}) {
                        Text("Contactar")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color(red: 225/255, green: 71/255, blue: 126/255))
                            .cornerRadius(25)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

// Modelo de datos que representa un promotor o evento
struct Promoter: Identifiable {
    let id: String
    let name: String
    let imageUrl: String
    let bio: String
    let eventsHosted: Int
    let rating: Double
}

// Vista previa para SwiftUI
#Preview {
    HomeView()
}
