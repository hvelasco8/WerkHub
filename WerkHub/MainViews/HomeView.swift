//
//  HomeView.swift
//  WerkHub
//
//  Created by Héctor Velasco on 14/2/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 217/255, blue: 245/255)                .ignoresSafeArea()
            Text("Inicio")
        }
    }
}

#Preview {
    HomeView()
}
