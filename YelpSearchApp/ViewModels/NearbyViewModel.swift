//
//  NearbyViewModel.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import Foundation

class NearbyViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var businesses: [Business] = []
    @Published var isLoading = false
    @Published var error: String?    
    
    init() {
    }
    
    func loadMore() {
        isLoading = true
        //TODO - ADD INFINITY SCROLL LOGIC
    }
}
