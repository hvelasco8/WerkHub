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
        Promoter(id: "1", name: "La Liada", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEu8qGVQswoO2LVQT_zFnV3a_d03HCItqJDg&s", bio: "Fiesta drag alternativa con DJ, shows y performances underground.", eventsHosted: 25, rating: 4.8),
        Promoter(id: "2", name: "This Is Drag", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWoMBci50GsHzZhR0s5wFJPVxd3BQtnrhRtA&s", bio: "El show drag más internacional de Madrid con Artistas invitadas.", eventsHosted: 40, rating: 4.9),
        Promoter(id: "3", name: "Roar Party", imageUrl: "https://roarparty.es/wp-content/uploads/2024/12/roar-party-2024-640x480.jpg", bio: "Eventos queer de música y cultura drag en salas icónicas de la ciudad.", eventsHosted: 30, rating: 4.6),
        Promoter(id: "4", name: "Maricoin", imageUrl: "https://maricoin.org/wp-content/uploads/2022/06/circulo-maricoin.png", bio: "Evento que une activismo, arte y fiesta para la comunidad LGTBIQ+.", eventsHosted: 12, rating: 4.7),
        Promoter(id: "5", name: "LL Show", imageUrl: "https://static.wixstatic.com/media/d82563_987bc055c769451f9f11251953e93ead.jpg", bio: "Experiencia drag deluxe con actuaciones coreografiadas en salas selectas.", eventsHosted: 18, rating: 4.5),
        Promoter(id: "6", name: "Drag is Burning", imageUrl: "https://dragisburning.com/wp-content/uploads/2024/02/Logo-Drag-is-Burning.png", bio: "Homenaje a la cultura ballroom y drag underground.", eventsHosted: 20, rating: 4.9),
        Promoter(id: "7", name: "Mood Pop Club", imageUrl: "https://pbs.twimg.com/profile_images/1846193013757722624/57s9an75_400x400.jpg", bio: "Club con visuales pop, DJ queer y shows drag cada viernes.", eventsHosted: 18, rating: 4.7),
        Promoter(id: "8", name: "Independance Club", imageUrl: "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F788868779%2F269258189388%2F1%2Foriginal.20240613-094011?w=512&auto=format%2Ccompress&q=75&sharp=10&rect=20%2C30%2C1032%2C1032&s=8658967ef9d859401cbf8a5f159295ca", bio: "Sesiones queer donde se mezcla electrónica y cultura drag alternativa.", eventsHosted: 22, rating: 4.4),
        Promoter(id: "9", name: "Tanga Party", imageUrl: "https://static.portalticket.com/prod/images/26/evento-principal-17432.jpg", bio: "Macrofiesta con coreos, drag queens, gogós y varios escenarios.", eventsHosted: 50, rating: 4.8),
        Promoter(id: "10", name: "Ultrapop", imageUrl: "https://lh3.googleusercontent.com/proxy/ueWP58EVwyza5oNUop6i-JDRaMr48d-hXymJfM9P3g5mXbJuAW-eLGE6RHdbpf4JiqIG3DGPMpwzeLVYCva6pMAJQCDEd5iF75AF8wYJ9xed_HXcHq0AZcA1-Hk", bio: "Pop sin complejos, ambiente libre y drags residentes.", eventsHosted: 35, rating: 4.5),
        Promoter(id: "11", name: "Boite Mix", imageUrl: "https://images.xceed.me/clubs/covers/boite-club-madrid-xceed.png?w=300&ar=1:1&fm=auto", bio: "Sala ecléctica con ambientazo queer y sesiones con performance.", eventsHosted: 15, rating: 4.3),
        Promoter(id: "12", name: "La Descará", imageUrl: "https://pbs.twimg.com/profile_images/1884221413474672640/4vT1QVG__400x400.jpg", bio: "Cabaret drag alternativo con Artistas queer y espectáculos únicos.", eventsHosted: 12, rating: 4.6)
    ]
    
    // Lista de Artistas
    let artists: [Artist] = [
        Artist(id: "1", name: "Sasha Colby", imageUrl: "https://i.scdn.co/image/ab6761610000e5ebefcf5dbe62cb9803b581471b", bio: "Artista drag reconocida internacionalmente por su talento y carisma.", style: "Glamour"),
        Artist(id: "2", name: "Monet X Change", imageUrl: "https://mnopera.org/wp-content/uploads/2022/12/Photo-Jun-05-1-23-04-AM-scaled.jpg", bio: "Drag queen y comediante que combina humor con arte visual.", style: "Comedia"),
        Artist(id: "3", name: "Bob the Drag Queen", imageUrl: "https://www.earwolf.com/wp-content/uploads/2020/04/6X0A8990-2.jpeg", bio: "Activista y performer, conocida por su personalidad arrolladora.", style: "Comedia"),
        Artist(id: "4", name: "Krystal Versace", imageUrl: "https://pbs.twimg.com/profile_images/1823467399300960256/ZaAkInpH_400x400.jpg", bio: "Joven promesa del drag con un estilo visual impactante.", style: "Fashion"),
        Artist(id: "5", name: "Jujubee", imageUrl: "https://imaging.broadway.com/images/regular-43/w735/129518-9.jpeg", bio: "Artista con gran trayectoria en el mundo del drag y la música.", style: "Versátil"),
        Artist(id: "6", name: "Kim Jayne", imageUrl: "https://pbs.twimg.com/profile_images/1880992939230240768/7kPaEIfh_400x400.jpg", bio: "Performer drag con espectáculos llenos de emoción.", style: "Drama"),
        Artist(id: "7", name: "Rebeca Santa María", imageUrl: "https://applications-media.feverup.com/image/upload/f_auto,w_320,h_320/fever2/plan/photo/e8f9ec16-0a37-11f0-aaea-1ef35eb1c46f", bio: "Artista que fusiona folclore y cultura drag en shows únicos.", style: "Folclore"),
        Artist(id: "8", name: "Ilse Alamierda", imageUrl: "https://pbs.twimg.com/profile_images/1820200000715976704/AfxPZXhz_400x400.jpg", bio: "Explora el drag desde lo conceptual y experimental.", style: "Conceptual"),
        Artist(id: "11", name: "La Bella Vampi", imageUrl: "https://img2.rtve.es/a/16536827/square/?h=320", bio: "Artista con un toque oscuro y teatral.", style: "Gothic"),
        Artist(id: "12", name: "Le Coco", imageUrl: "https://es.e-noticies.cat/filesedc/uploads/image/post/le-coco-ganadora-drag-race_1600_1067.jpg", bio: "Estética retro y actitud desenfadada en el escenario.", style: "Retro"),
        Artist(id: "13", name: "Chloe Vittu", imageUrl: "https://imagenes.atresplayer.com/atp/clipping/cmsimages02/2024/09/04/188F7182-C1B4-4AB1-A6CE-CB265E789AC9//720x960.jpg", bio: "Fusiona baile y lip-sync en espectáculos cautivadores.", style: "Dance"),
        Artist(id: "14", name: "Lassie Verguenza", imageUrl: "https://scontent-lhr8-1.cdninstagram.com/v/t51.2885-19/455348322_847102197066659_3356357609080971718_n.jpg?stp=dst-jpg_s640x640_tt6&_nc_ht=scontent-lhr8-1.cdninstagram.com&_nc_cat=111&_nc_oc=Q6cZ2QFP4Ces6yk6jOm5BB5smd1bZXM2mKMXRlMUs4xw_IrpEltwXjgjexlVsvJd5d0uxgQ&_nc_ohc=pv8hv7__wdUQ7kNvwERnfBP&_nc_gid=Bhq-ZW8FiX4EWBvxn3BEYA&edm=APs17CUBAAAA&ccb=7-5&oh=00_AfJyuMeTxfgc7v9HvPcQNEjAbwD68FyX6TzetZkQ8Jczbw&oe=68412FCC&_nc_sid=10d13b", bio: "Actuaciones divertidas que sacan sonrisas.", style: "Comedia")
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
