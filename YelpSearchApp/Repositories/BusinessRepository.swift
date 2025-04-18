//
//  BusinessRepository.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import Foundation
import Combine

protocol BusinessRepositoryProtocol {
    func searchBusinesses(term: String, offset: Int) -> AnyPublisher<[Business], Error>
    func autocomplete(term: String) -> AnyPublisher<[SearchTerm], Error>
}

final class BusinessRepository: BusinessRepositoryProtocol {
    private let apiService: YelpAPIService

    init(apiService: YelpAPIService = .shared) {
        self.apiService = apiService
    }

    func searchBusinesses(term: String, offset: Int) -> AnyPublisher<[Business], Error> {
        return apiService.searchBusinesses(term: term, offset: offset)
    }
    
    func autocomplete(term: String) -> AnyPublisher<[SearchTerm], Error> {
        return apiService.autocomplete(term: term)
    }
}
