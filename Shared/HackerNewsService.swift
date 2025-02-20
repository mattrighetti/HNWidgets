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

        static var allCases: [HNList] = [.asknew, .best, .home, .shownew]

        static var caseDisplayRepresentations: [HackerNewsService.HNList : DisplayRepresentation] {
            [
                .asknew : "asknew",
                .best : "best",
                .home : "home",
                .shownew: "shownew",
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

    // Fetches stories for a given category with a limit
    func fetchStories(for category: HNList, limit: Int) async throws -> [HNStory] {
        let storyIDs = try await fetchStoryIDs(for: category)
        return try await withThrowingTaskGroup(of: HNStory.self) { group in
            var stories = [HNStory]()

            for storyID in storyIDs.prefix(limit) {
                group.addTask {
                    return try await self.fetchStoryDetails(id: storyID)
                }
            }

            for try await story in group {
                stories.append(story)
            }

            return stories
        }
    }
}
