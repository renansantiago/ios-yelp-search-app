//
//  FavoritesRepository.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import Foundation

class FavoritesRepository {
    private let key = "favorites"

    func load() -> [Business] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let businesses = try? JSONDecoder().decode([Business].self, from: data) else {
            return []
        }
        return businesses
    }

    func save(_ businesses: [Business]) {
        if let data = try? JSONEncoder().encode(businesses) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
