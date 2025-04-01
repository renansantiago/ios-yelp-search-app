//
//  BusinessDetailView.swift
//  YelpSearchApp
//
//  Created by Renan on 01/04/25.
//

import SwiftUI
import SafariServices

struct BusinessDetailView: View {
    let business: Business
    @State private var showWebView = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
            Text(business.name).font(.largeTitle).padding()
            Button("Open in Safari") {
                if let url = URL(string: business.url) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Open in WebView") {
                showWebView = true
            }
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .sheet(isPresented: $showWebView) {
            SafariWebView(url: URL(string: business.url)!)
        }
    }
}

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
