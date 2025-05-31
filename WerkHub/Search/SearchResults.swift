//
//  EventCard.swift
//  WerkHub
//
//  Created by Héctor Velasco on 31/5/25.
//

import SwiftUI

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

struct PromoterResultCard: View {
    let promoter: Promoter

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(promoter.name)
                .font(.headline)
                .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))

            Text("Eventos: \(promoter.eventsHosted)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(promoter.bio)
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

struct ArtistResultCard: View {
    let artist: Artist

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(artist.name)
                .font(.headline)
                .foregroundColor(Color(red: 225/255, green: 71/255, blue: 126/255))

            Text("Estilo: \(artist.style)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(artist.bio)
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
