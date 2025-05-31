//
//  PromoterCard.swift
//  WerkHub
//
//  Created by Héctor Velasco on 31/5/25.
//

import SwiftUI

struct PromoterCard: View {
    let promoter: Promoter
    
    var body: some View {
        VStack(spacing: 8) {
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

struct ArtistCard: View {
    let artist: Artist
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: artist.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "person.crop.circle.fill")
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
            
            Text(artist.name)
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
