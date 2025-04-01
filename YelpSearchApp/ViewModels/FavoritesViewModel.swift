//
//  FavoritesViewModel.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Business] = []
    
    private let repository: FavoritesRepository

    init(repository: FavoritesRepository = FavoritesRepository()) {
        self.repository = repository
        loadFavorites()
    }

    func loadFavorites() {
        favorites = repository.load()
    }

    func toggleFavorite(_ business: Business) {
        favorites = repository.load()
        if let index = favorites.firstIndex(where: { $0.id == business.id }) {
            favorites.remove(at: index)
        } else {
            var updated = business
            updated.isFavorite = true
            favorites.append(updated)
        }
        repository.save(favorites)
    }

    func isFavorite(_ business: Business) -> Bool {
        favorites.contains(business)
    }
}
