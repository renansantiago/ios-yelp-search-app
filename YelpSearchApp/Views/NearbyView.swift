//
//  NearbyView.swift
//  YelpSearchApp
//
//  Created by Renan on 31/03/25.
//

import SwiftUI

struct NearbyView: View {
    @Binding var selectedTab: Tab
    @StateObject var viewModel = NearbyViewModel()
    @StateObject var favoritesVM = FavoritesViewModel()
    @State private var selectedBusiness: Business?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                if !viewModel.autocompleteSuggestions.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.autocompleteSuggestions, id: \.self) { suggestion in
                                Button(action: {
                                    viewModel.searchText = suggestion
                                }) {
                                    Text(suggestion)
                                        .padding(8)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                }
                            }
                        }.padding(.horizontal)
                    }
                }

                if let error = viewModel.error {
                    Text(error).foregroundColor(.red).padding()
                } else {
                    List {
                        ForEach(viewModel.businesses) { business in
                            BusinessRow(business: business)
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle("Nearby")
            .sheet(item: $selectedBusiness) { business in
                BusinessDetailView(business: business)
            }
        }
        .onAppear {
            if selectedTab == .nearby {
                viewModel.loadFavorites()
            }
        }
    }

    @ViewBuilder
    private func BusinessRow(business: Business) -> some View {
        BusinessRowView(
            business: business,
            toggleFavorite: {
                favoritesVM.toggleFavorite(business)
                viewModel.loadFavorites()
            },
            onSelect: {
                selectedBusiness = business
            }
        )
        .onTapGesture {
            selectedBusiness = business
        }
        .onAppear {
            if business == viewModel.businesses.last {
                viewModel.loadMore()
            }
        }
    }
}

#Preview {
    NearbyView(selectedTab: .constant(.nearby))
}
