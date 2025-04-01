//
//  NearbyView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct NearbyView: View {
    @StateObject var viewModel = NearbyViewModel()
    @StateObject var favoritesVM = FavoritesViewModel()
    @State private var selectedBusiness: Business?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List {
                    ForEach(viewModel.businesses) { business in
                        BusinessRow(business: business)
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Nearby")
        }
    }

    @ViewBuilder
    private func BusinessRow(business: Business) -> some View {
        BusinessRowView(
            business: business,
            isFavorite: favoritesVM.isFavorite(business),
            toggleFavorite: {
                favoritesVM.toggleFavorite(business)
            }
        )
        .onTapGesture {
            selectedBusiness = business
        }
        .onAppear {
            if business == viewModel.businesses.last {
                viewModel.loadMore()
            }
        }
    }
}

#Preview {
    NearbyView()
}
