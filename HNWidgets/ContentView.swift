//
//  ContentView.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hacker News")
        }
        .padding()
        .onOpenURL(perform: { url in
            guard let urlComponents = URLComponents(string: url.absoluteString) else { return }
            guard
                url.scheme == "hnwidgets",
                url.host == "openlink",
                let link = urlComponents.queryItems?.first(where: { $0.name == "link" })?.value
            else { return }

            openURL(URL(string: link)!)
        })
    }
}

#Preview {
    ContentView()
}
