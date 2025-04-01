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
    private  var lastSearchResults: [Business] = []
    
    init(repository: BusinessRepositoryProtocol = BusinessRepository()) {
        self.repository = repository
        
        search(term: "")

        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self = self else { return }
                
                if !term.isEmpty {
                    self.fetchAutocompleteSuggestions(for: term)
                    self.search(term: term)
                }
            }
            .store(in: &cancellables)
    }
    
    func search(term: String) {
        if term.isEmpty {
            currentSearchTerm = ""
            if !initialResults.isEmpty {
                businesses = initialResults
                return
            }
        } else {
            currentSearchTerm = term
            if businesses == lastSearchResults {
                return
            }
        }

        isLoading = true
        error = nil
        offset = 0
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
            }, receiveValue: { [weak self] newBusinesses in
                guard let self = self else { return }
                self.businesses += newBusinesses
                self.offset += newBusinesses.count
                self.canLoadMore = !newBusinesses.isEmpty
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
}
