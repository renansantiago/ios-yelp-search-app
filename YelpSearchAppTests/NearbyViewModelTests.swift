//
//  NearbyViewModelTests.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import XCTest
import Combine
@testable import YelpSearchApp

final class NearbyViewModelTests: XCTestCase {
    var viewModel: NearbyViewModel!
    var mockRepo: MockBusinessRepository!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockRepo = MockBusinessRepository()
        viewModel = NearbyViewModel(repository: mockRepo)
    }

    func testSearchPopulatesBusinesses() {
        let expectation = self.expectation(description: "Businesses loaded")
        let testBusiness = Business(id: "1", name: "Test Pizza", imageUrl: "", rating: 4.5, url: "https://yelp.com")

        mockRepo.mockBusinesses = [testBusiness]

        viewModel.searchText = "pizza"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            XCTAssertEqual(self.viewModel.businesses.first?.id, testBusiness.id)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testLoadFavoritesUpdatesIsFavoriteFlag() {
        let business = sampleBusiness(id: "biz1")
        let favorite = sampleBusiness(id: "biz1", isFavorite: true)

        let repo = FavoritesRepository()
        repo.save([favorite])

        viewModel._injectInitialResults([business])
        viewModel.loadFavorites()

        XCTAssertEqual(viewModel.businesses.first?.isFavorite, true)
    }
}
