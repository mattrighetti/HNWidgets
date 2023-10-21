//
//  File.swift
//  
//
//  Created by Mattia Righetti on 21/10/23.
//

import Foundation

enum FetchError: Error {
    case failure
}

struct HNPageFetcher {
    public static let shared = HNPageFetcher()

    private let baseUrl = "https://news.ycombinator.com"
    private init() {}

    private func getHomeArticles() async throws -> Data {
        let url = URL(string: baseUrl)!
        let req = URLRequest(url: url)
        
        let (data, res) = try await URLSession.shared.data(for: req)
        guard let httpResponse = res as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FetchError.failure
        }

        return data
    }

    public func getHNLinks() async throws -> [HNLink] {
        let data = try await getHomeArticles()
        return HTMLParser(html: String(data: data, encoding: .utf8)!)!.getHNLinks()
    }
}
