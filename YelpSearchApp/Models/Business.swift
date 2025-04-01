//
//  Business.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import Foundation

struct Business: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let imageUrl: String
    let rating: Double
    let url: String

    enum CodingKeys: String, CodingKey {
        case id, name, rating, url
        case imageUrl = "image_url"
    }
}

struct BusinessSearchResponse: Codable {
    let businesses: [Business]
}
