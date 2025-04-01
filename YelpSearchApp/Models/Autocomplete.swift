//
//  Autocomplete.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import Foundation

struct AutocompleteResponse: Codable {
    let terms: [SearchTerm]
}

struct SearchTerm: Codable {
    let text: String
}
