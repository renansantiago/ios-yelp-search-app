//
//  FavoritesView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    @State private var selectedBusiness: Business?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favorites) { business in
                    BusinessRowView(
                        business: business,
                        isFavorite: true,
                        toggleFavorite: {
                            viewModel.toggleFavorite(business)
                        }
                    )
                    .onTapGesture {
                        selectedBusiness = business
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
