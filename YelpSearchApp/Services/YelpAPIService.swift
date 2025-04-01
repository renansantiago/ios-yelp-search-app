//
//  YelpAPIService.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import Foundation
import Combine

final class YelpAPIService {
    static let shared = YelpAPIService()
    private init() {}
    
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    func searchBusinesses(term: String, offset: Int = 0) -> AnyPublisher<[Business], Error> {
        let urlStr = "\(Constants.baseURL)/businesses/search?term=\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&latitude=\(Constants.defaultLatitude)&longitude=\(Constants.defaultLongitude)&limit=20&offset=\(offset)"
        
        guard let url = URL(string: urlStr) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: BusinessSearchResponse.self, decoder: JSONDecoder())
            .map { $0.businesses }
            .eraseToAnyPublisher()
    }
    
    func autocomplete(term: String) -> AnyPublisher<[SearchTerm], Error> {
        guard let url = URL(string: "\(Constants.baseURL)/autocomplete?text=\(term)&latitude=\(Constants.defaultLatitude)&longitude=\(Constants.defaultLongitude)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")

        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AutocompleteResponse.self, decoder: JSONDecoder())
            .map { $0.terms }
            .eraseToAnyPublisher()
    }
}
