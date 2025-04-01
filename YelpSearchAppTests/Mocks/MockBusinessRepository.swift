//
//  MockBusinessRepository.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import Foundation
import Combine
@testable import YelpSearchApp

final class MockBusinessRepository: BusinessRepositoryProtocol {
    var mockBusinesses: [Business] = []
    var mockAutocomplete: [SearchTerm] = []

    func searchBusinesses(term: String, offset: Int) -> AnyPublisher<[Business], Error> {
        Just(mockBusinesses)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func autocomplete(term: String) -> AnyPublisher<[SearchTerm], Error> {
        Just(mockAutocomplete)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
