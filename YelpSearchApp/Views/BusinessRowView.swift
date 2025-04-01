//
//  BusinessRowView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct BusinessRowView: View {
    let business: Business
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: business.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(business.name).font(.headline)
                Text("Rating: \(business.rating)").font(.subheadline)
            }
            Spacer()
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    BusinessRowView(
        business: Business(id: "1", name: "", imageUrl: "", rating: 0, url: ""),
        isFavorite: false,
        toggleFavorite: {}
    )
}
