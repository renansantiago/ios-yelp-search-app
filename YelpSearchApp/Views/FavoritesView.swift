//
//  FavoritesView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var selectedTab: Tab
    @StateObject var viewModel = FavoritesViewModel()
    @State private var selectedBusiness: Business?

    var body: some View {
        NavigationView {
            if viewModel.favorites.isEmpty {
                VStack {
                    Spacer()
                    Text("You haven't added any businesses to your favorites yet.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                .navigationTitle("Favorites")
            } else {
                List {
                    ForEach(viewModel.favorites) { business in
                        BusinessRowView(
                            business: business,
                            toggleFavorite: {
                                viewModel.toggleFavorite(business)
                            },
                            onSelect: {
                                selectedBusiness = business
                            }
                        )
                        .onTapGesture {
                            selectedBusiness = business
                        }
                    }
                }
                .navigationTitle("Favorites")
                .sheet(item: $selectedBusiness) { business in
                    BusinessDetailView(business: business)
                }
            }
        }
        .onAppear {
            if selectedTab == .favorites {
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview {
    FavoritesView(selectedTab: .constant(.favorites))
}
