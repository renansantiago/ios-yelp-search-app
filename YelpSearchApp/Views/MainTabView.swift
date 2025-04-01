//
//  MainTabView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NearbyView()
                .tabItem {
                    Label("Nearby", systemImage: "magnifyingglass")
                }
        }
    }
}
