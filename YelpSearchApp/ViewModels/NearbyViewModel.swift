//
//  NearbyViewModel.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import Foundation
import Combine

class NearbyViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var businesses: [Business] = []
    @Published var isLoading = false
    @Published var error: String?    
    
    private let repository: BusinessRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var offset = 0
    private var canLoadMore = true
    private var currentSearchTerm = ""
    
    init(repository: BusinessRepositoryProtocol = BusinessRepository()) {
        self.repository = repository

        $searchText            
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self = self else { return }
                self.search(term: term)
            }
            .store(in: &cancellables)
    }
    
    func search(term: String) {
        guard !term.isEmpty else {
            businesses = []
            return
        }

        isLoading = true
        error = nil
        offset = 0
        currentSearchTerm = term
        canLoadMore = true

        repository.searchBusinesses(term: term, offset: 0)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.error = self.userFriendlyError(err)
                }
            }, receiveValue: { [weak self] businesses in
                self?.businesses = businesses
                self?.offset = businesses.count
                self?.canLoadMore = !businesses.isEmpty
            })
            .store(in: &cancellables)
    }
    
    func loadMore() {
        guard canLoadMore, !isLoading else { return }

        isLoading = true
        repository.searchBusinesses(term: currentSearchTerm, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let err) = completion {
                    self?.error = self?.userFriendlyError(err)
                }
            }, receiveValue: { [weak self] newBusinesses in
                guard let self = self else { return }
                self.businesses += newBusinesses
                self.offset += newBusinesses.count
                self.canLoadMore = !newBusinesses.isEmpty
            })
            .store(in: &cancellables)
    }
    
    private func userFriendlyError(_ error: Error) -> String {
        let nsError = error as NSError

        if nsError.code == NSURLErrorTimedOut {
            return "Request timed out. Try again later."
        } else if nsError.code == NSURLErrorNotConnectedToInternet {
            return "No internet connection."
        } else if nsError.code == 429 {
            return "You’ve reached the API limit. Try again later."
        }

        return nsError.localizedDescription
    }
}
