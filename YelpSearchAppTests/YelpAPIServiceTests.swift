//
//  YelpAPIServiceTests.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import XCTest
@testable import YelpSearchApp
import Combine

final class YelpAPIServiceTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func testBusinessSearchReturnsResults() {
        let expectation = self.expectation(description: "Business search should return results")
        var results: [Business]?

        YelpAPIService.shared.searchBusinesses(term: "pizza")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { businesses in
                results = businesses
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
        XCTAssertNotNil(results)
        XCTAssertGreaterThan(results?.count ?? 0, 0)
    }

    func testAutocompleteReturnsSuggestions() {
        let expectation = self.expectation(description: "Autocomplete should return suggestions")
        var results: [SearchTerm]?

        YelpAPIService.shared.autocomplete(term: "sush")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { terms in
                results = terms
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
        XCTAssertNotNil(results)
        XCTAssertGreaterThan(results?.count ?? 0, 0)
    }
}
