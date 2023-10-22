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
    enum HNList: String, CaseIterable {
        case home
        case best
        case shownew
        case asknew
        case launches
        case whoishiring
        case pool
        case invited
        case active
        case noobstories
        case classic

        static var allCases: [HNPageFetcher.HNList] = [
            .active, .asknew, .best, .classic, .home,
            .invited, .launches, .noobstories, .pool,
            .shownew, .whoishiring
        ]

        var url: URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "news.ycombinator.com"
            
            switch self {
            case .home: break
            case .whoishiring:
                urlComponents.path = "/submitted"
                urlComponents.query = "id=" + self.rawValue
            default:
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

    public func getHNLinks(from list: HNList? = .home) async -> Result<[HNLink], Error> {
        guard let data = try? await getArticles(from: list) else {
            return .failure(FetchError.failure)
        }

        guard
            let htmlString = String(data: data, encoding: .utf8),
            let parser = HTMLParser(html: htmlString)
        else { return .failure(ParserError.htmlParseError) }

        let links = parser.getHNLinks()
        if links.count > 0 {
            return .success(links)
        }
        
        return .failure(ParserError.unknown)
    }
}
