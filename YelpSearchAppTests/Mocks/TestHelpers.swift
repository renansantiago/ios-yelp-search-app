//
//  TestHelpers.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import Foundation
@testable import YelpSearchApp

func sampleBusiness(id: String = UUID().uuidString, isFavorite: Bool = false) -> Business {
    Business(
        id: id,
        name: "Business \(id.prefix(4))",
        imageUrl: "https://example.com/image.jpg",
        rating: 4.5,
        url: "https://example.com",
        isFavorite: isFavorite
    )
}
