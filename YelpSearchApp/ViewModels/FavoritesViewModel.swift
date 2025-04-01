//
//  FavoritesViewModel.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Business] = []

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        //HANDLE LOAD FAVORITES
    }

    func toggleFavorite(_ business: Business) {
        if let index = favorites.firstIndex(of: business) {
            favorites.remove(at: index)
        } else {
            favorites.append(business)
        }
        //HANDLE FAVORITE PERSIST
    }

    func isFavorite(_ business: Business) -> Bool {
        favorites.contains(business)
    }
}
