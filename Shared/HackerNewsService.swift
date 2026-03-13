//
//  HNFetcher.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 2/20/25.
//

import Foundation
import AppIntents

enum HNError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

actor HackerNewsService {
    private let baseURL = "https://hacker-news.firebaseio.com/v0"

    public static let shared = HackerNewsService()

    enum HNList: String, CaseIterable, AppEnum {
        case home = "topstories"
        case best = "beststories"
        case shownew = "showstories"
        case asknew = "askstories"

        static var caseDisplayRepresentations: [HackerNewsService.HNList: DisplayRepresentation] {
            [
                .home: "Top Stories",
                .best: "Best Stories",
                .shownew: "Show HN",
                .asknew: "Ask HN",
            ]
        }

        static var typeDisplayRepresentation: TypeDisplayRepresentation {
            TypeDisplayRepresentation(name: "List")
        }
    }

    private func fetchStoryIDs(for category: HNList) async throws -> [Int] {
        let url = URL(string: "\(baseURL)/\(category.rawValue).json")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw HNError.invalidResponse
        }

        return try JSONDecoder().decode([Int].self, from: data)
    }

    private func fetchStoryDetails(id: Int) async throws -> HNStory {
        let url = URL(string: "\(baseURL)/item/\(id).json")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw HNError.invalidResponse
        }

        return try JSONDecoder().decode(HNStory.self, from: data)
    }

    // Fetches stories for a given category with a limit, preserving HN's ranked order
    func fetchStories(for category: HNList, limit: Int) async throws -> [HNStory] {
        let storyIDs = Array(try await fetchStoryIDs(for: category).prefix(limit))
        return try await withThrowingTaskGroup(of: (Int, HNStory).self) { group in
            var storiesByID = [Int: HNStory]()
            storiesByID.reserveCapacity(storyIDs.count)

            for (index, storyID) in storyIDs.enumerated() {
                group.addTask {
                    return (index, try await self.fetchStoryDetails(id: storyID))
                }
            }

            for try await (index, story) in group {
                storiesByID[index] = story
            }

            return storyIDs.indices.compactMap { storiesByID[$0] }
        }
    }
}
