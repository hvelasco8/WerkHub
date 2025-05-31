//
//  PromoterProfileView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 31/5/25.
//

import SwiftUI

struct PromoterProfileView: View {
    let promoter: Promoter
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
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
                    
                    Text(promoter.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
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
                    
                    Text(promoter.bio)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
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

struct ArtistProfileView: View {
    let artist: Artist
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
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
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 20)
                    
                    Text(artist.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    VStack(spacing: 10) {
                        Text("Estilo: \(artist.style)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text(artist.bio)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.9))
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        // Acción para contactar
                    }) {
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
