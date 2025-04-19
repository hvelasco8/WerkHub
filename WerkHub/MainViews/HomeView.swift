import SwiftUI

struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
}

struct HomeView: View {
    
    // Custom background color
    let customBackgroundColor = Color(red: 255/255, green: 217/255, blue: 245/255)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Big Banner with Text "Anuncios"
                ZStack {
                    Color.white // Background color for the banner
                        .frame(width: 367, height: 150)
                    
                    Text("Anuncios")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 255/255, green: 217/255, blue: 245/255)) // Custom color for text
                }
                .cornerRadius(20)
                .padding(10)
                
                // Two-column grid of cards
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                }
                .padding(16)
            }
        }
        .background(customBackgroundColor) // Set the custom background color for the entire view
    }
}

struct ProfileCard: View {
    let profile: Profile
    
    var body: some View {
        VStack {
            Image(systemName: profile.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding()
                .background(Color.white.opacity(0.8)) // Light white background for the icon
                .clipShape(Circle())
            
            Text(profile.name)
                .font(.headline)
                .foregroundColor(.black) // Black text for better contrast
                .padding(.top, 8)
            
            Text(profile.description)
                .font(.subheadline)
                .foregroundColor(.gray) // Gray text for subtler description
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white) // White background for the card
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    HomeView()
}
