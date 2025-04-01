//
//  FavoritesViewModelTests.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import XCTest
@testable import YelpSearchApp

final class FavoritesViewModelTests: XCTestCase {
    var viewModel: FavoritesViewModel!
    var mockRepo: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockRepo = MockFavoritesRepository()
        viewModel = FavoritesViewModel(repository: mockRepo)
    }

    func testToggleFavoriteAddsNewItem() {
        let newBusiness = sampleBusiness(id: "xyz")
        viewModel.toggleFavorite(newBusiness)

        XCTAssertTrue(viewModel.favorites.contains(where: { $0.id == "xyz" }))
        XCTAssertTrue(mockRepo.savedFavorites.contains(where: { $0.id == "xyz" }))
        XCTAssertTrue(mockRepo.savedFavorites.allSatisfy { $0.isFavorite })
    }

    func testToggleFavoriteRemovesItem() {
        let biz = sampleBusiness(id: "remove-me", isFavorite: true)
        mockRepo.mockFavorites = [biz]
        viewModel.loadFavorites()

        viewModel.toggleFavorite(biz)
        XCTAssertFalse(viewModel.favorites.contains(where: { $0.id == "remove-me" }))
        XCTAssertTrue(mockRepo.savedFavorites.isEmpty)
    }
}
