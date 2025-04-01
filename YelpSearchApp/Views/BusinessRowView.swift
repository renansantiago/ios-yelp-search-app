//
//  BusinessRowView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct BusinessRowView: View {
    let business: Business
    let toggleFavorite: () -> Void
    let onSelect: () -> Void

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
                Text(business.name)
                    .font(.headline)
                Text("Rating: \(business.rating)")
                    .font(.subheadline)
            }

            Spacer()

            Button(action: toggleFavorite) {
                Image(systemName: business.isFavorite ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    BusinessRowView(
        business: Business(id: "1", name: "", imageUrl: "", rating: 0, url: ""),
        toggleFavorite: {},
        onSelect: {}
    )
}
