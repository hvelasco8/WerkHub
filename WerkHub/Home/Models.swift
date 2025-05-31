//
//  Artist.swift
//  WerkHub
//
//  Created by Héctor Velasco on 31/5/25.
//

import Foundation

struct Artist: Identifiable {
    let id: String
    let name: String
    let imageUrl: String
    let bio: String
    let style: String
}

struct Promoter: Identifiable {
    let id: String
    let name: String
    let imageUrl: String
    let bio: String
    let eventsHosted: Int
    let rating: Double
}
