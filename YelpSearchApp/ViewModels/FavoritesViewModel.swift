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
        if let index = favorites.firstIndex(of: business) {
            favorites.remove(at: index)
        } else {
            favorites.append(business)
        }
        repository.save(favorites)
    }

    func isFavorite(_ business: Business) -> Bool {
        favorites.contains(business)
    }
}
