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

enum ParserError: Error {
    case htmlParseError
    case unknown
}

struct HNPageFetcher {
    enum HNList: String {
        case home, best, shownew, asknew,
             launches, whoishiring, pool, invited,
             highlights, active, noobstories, classic, leaders

        var url: URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "news.ycombinator.com"
            if self != .home {
                urlComponents.path = "/" + self.rawValue
            }
            return urlComponents.url!
        }
    }

    public static let shared = HNPageFetcher()

    private init() {}

    private func getArticles(from list: HNList? = .home) async throws -> Data {
        var req = URLRequest(url: list!.url)
        req.setValue("HNWidgets", forHTTPHeaderField: "User-Agent")

        let (data, res) = try await URLSession.shared.data(for: req)
        guard let httpResponse = res as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FetchError.failure
        }

        return data
    }

    public func getHNLinks(from list: HNList? = .home) async throws -> Result<[HNLink], ParserError> {
        let data = try await getArticles(from: list)

        guard let htmlString = String(data: data, encoding: .utf8),
              let parser = HTMLParser(html: htmlString)
        else { return .failure(.htmlParseError) }

        let links = parser.getHNLinks()
        if links.count > 0 {
            return .success(links)
        }
        
        return .failure(.unknown)
    }
}
