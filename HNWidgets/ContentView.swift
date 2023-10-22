//
//  ContentView.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    
    @State var loading: Bool = true
    @State var links: [HNLink]

    var body: some View {
        NavigationView {
            if loading {
                Text("Loading...")
                    .navigationTitle("Hacker News")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                List {
                    ForEach(0..<links.count) { i in
                        Link(destination: URL(string: links[i].url)!, label: {
                            HStack(alignment: .top) {
                                Text("\(i + 1).")
                                    .font(.system(size: 13, weight: .light))
                                    .padding(.top, 1)
                                HNLinkRow(link: links[i])
                            }
                        })
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Hacker News")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            self.loading = true
            Task {
                if case .success(let links) = try await HNPageFetcher.shared.getHNLinks() {
                    self.links = links
                    self.loading = false
                } else {
                    print("error")
                }
            }
        }
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
    ContentView(links: [
        HNLink(id: "37967936", title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: "2", upvotes: "23", elapsed: "27 minutes ago"),
        HNLink(id: "37967126", title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: "15", upvotes: "80", elapsed: "1 hour ago"),
        HNLink(id: "37967751", title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: "3", upvotes: "11", elapsed: "20 minutes ago"),
        HNLink(id: "37967936", title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: "2", upvotes: "23", elapsed: "27 minutes ago"),
        HNLink(id: "37967126", title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: "15", upvotes: "80", elapsed: "1 hour ago"),
        HNLink(id: "37967751", title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: "3", upvotes: "11", elapsed: "20 minutes ago"),
        HNLink(id: "37967751", title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: "3", upvotes: "11", elapsed: "20 minutes ago"),
        HNLink(id: "37967936", title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: "2", upvotes: "23", elapsed: "27 minutes ago"),
        HNLink(id: "37967126", title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: "15", upvotes: "80", elapsed: "1 hour ago"),
        HNLink(id: "37967751", title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: "3", upvotes: "11", elapsed: "20 minutes ago"),
        HNLink(id: "37967936", title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: "2", upvotes: "23", elapsed: "27 minutes ago"),
        HNLink(id: "37967126", title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: "15", upvotes: "80", elapsed: "1 hour ago"),
        HNLink(id: "37967751", title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: "3", upvotes: "11", elapsed: "20 minutes ago"),
        HNLink(id: "37967751", title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: "3", upvotes: "11", elapsed: "20 minutes ago")
    ])
}
