//
//  MainTabView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

enum Tab: Hashable {
    case nearby
    case favorites
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .nearby
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NearbyView(
                selectedTab: $selectedTab
            )
            .tabItem {
                Label("Nearby", systemImage: "magnifyingglass")
            }
            .tag(Tab.nearby)
            
            FavoritesView(
                selectedTab: $selectedTab
            )
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            .tag(Tab.favorites)
        }
    }
}

#Preview {
    MainTabView()
}
