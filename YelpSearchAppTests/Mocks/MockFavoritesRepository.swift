//
//  MockFavoritesRepository.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import Foundation
@testable import YelpSearchApp

final class MockFavoritesRepository: FavoritesRepository {
    var mockFavorites: [Business] = []
    var savedFavorites: [Business] = []

    override func load() -> [Business] {
        return mockFavorites
    }

    override func save(_ businesses: [Business]) {
        savedFavorites = businesses
        mockFavorites = businesses
    }
}
