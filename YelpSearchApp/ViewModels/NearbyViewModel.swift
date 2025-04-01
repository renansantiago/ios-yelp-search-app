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
    @Published var autocompleteSuggestions: [String] = []
    
    private let repository: BusinessRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var offset = 0
    private var canLoadMore = true
    private var currentSearchTerm = ""
    private var hasLoadedInitially = false
    private var favorites: [Business] = []
    private var initialResults: [Business] = []
    private var lastSearchResults: [Business] = []
    private var hasPerformedInitialSearch = false
    
    init(repository: BusinessRepositoryProtocol = BusinessRepository()) {
        self.repository = repository

        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self = self else { return }
                
                if term.isEmpty {
                    if !self.initialResults.isEmpty {
                        self.businesses = self.initialResults
                    } else {
                        self.search(term: "")
                    }
                } else {
                    self.fetchAutocompleteSuggestions(for: term)
                    self.search(term: term)
                }
            }
            .store(in: &cancellables)
        
        search(term: "")
    }
    
    func search(term: String) {
        if term.isEmpty && hasPerformedInitialSearch {
            businesses = initialResults
            return
        }

        isLoading = true
        error = nil
        offset = 0
        currentSearchTerm = term
        canLoadMore = true

        repository.searchBusinesses(term: currentSearchTerm, offset: 0)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = self?.userFriendlyError(error)
                }
            }, receiveValue: { [weak self] businesses in
                guard let self = self else { return }
                let updated = self.applyFavorites(to: businesses)
                self.businesses = updated
                self.offset = businesses.count
                self.canLoadMore = !businesses.isEmpty

                if term.isEmpty {
                    self.initialResults = updated
                    self.hasPerformedInitialSearch = true
                } else {
                    self.lastSearchResults = updated
                }
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
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                let updated = self.applyFavorites(to: results)
                self.businesses += updated
                self.offset += updated.count
                self.canLoadMore = !updated.isEmpty
                
                if currentSearchTerm.isEmpty {
                    self.initialResults = self.businesses
                } else {
                    self.lastSearchResults = self.businesses
                }
            })
            .store(in: &cancellables)
    }
    
    func loadFavorites() {
        if currentSearchTerm.isEmpty {
            businesses = applyFavorites(to: initialResults)
        } else {
            businesses = applyFavorites(to: lastSearchResults)
        }
    }
    
    private func applyFavorites(to list: [Business]) -> [Business] {
        let favoriteIDs = Set(FavoritesRepository().load().map { $0.id })
        return list.map { business in
            var updated = business
            updated.isFavorite = favoriteIDs.contains(business.id)
            return updated
        }
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
    
    func fetchAutocompleteSuggestions(for term: String) {
        guard !term.isEmpty else {
            autocompleteSuggestions = []
            return
        }

        repository.autocomplete(term: term)
            .map { $0.map { $0.text } }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$autocompleteSuggestions)
    }
    
#if DEBUG
func _injectInitialResults(_ businesses: [Business]) {
    self.initialResults = applyFavorites(to: businesses)
    self.businesses = self.initialResults
}
#endif
}
