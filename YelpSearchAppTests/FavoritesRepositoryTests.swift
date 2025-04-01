//
//  FavoritesRepositoryTests.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import XCTest
@testable import YelpSearchApp

final class FavoritesRepositoryTests: XCTestCase {
    func testSaveAndLoadFavorites() {
        let repo = FavoritesRepository()
        let business = sampleBusiness(id: "abc", isFavorite: true)

        repo.save([business])
        let loaded = repo.load()

        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.id, "abc")
        XCTAssertTrue(loaded.first?.isFavorite == true)
    }
}
