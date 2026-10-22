//
//  WidgetConfigurationIntent.swift
//  HNWidgetExtension
//
//  Created by Mattia Righetti on 22/10/23.
//

import WidgetKit
import AppIntents
import Foundation

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Select List"
    static let description = IntentDescription("Select HN List to fetch links from")

    @Parameter(title: "Update every", default: .five)
    var reload: UpdateEveryIntent

    @Parameter(title: "List", default: .home)
    var list: HackerNewsService.HNList

    @Parameter(title: "Redirect", default: .story)
    var redirectTo: Redirect
}

@MainActor
enum WidgetStorySelection {
    private static func indexKey(for feedID: String, pageSize: Int) -> String {
        "selectedStoryPage.\(feedID).\(pageSize)"
    }

    private static func storiesKey(for feedID: String) -> String {
        "cachedStories.\(feedID)"
    }

    private static func interactiveReloadKey(for feedID: String) -> String {
        "interactiveReload.\(feedID)"
    }

    static func currentPage(feedID: String, pageSize: Int, maxPageIndex: Int) -> Int {
        min(UserDefaults.standard.integer(forKey: indexKey(for: feedID, pageSize: pageSize)), max(0, maxPageIndex))
    }

    static func cache(_ stories: [HNStory], feedID: String) {
        guard let data = try? JSONEncoder().encode(stories) else { return }
        UserDefaults.standard.set(data, forKey: storiesKey(for: feedID))
    }

    static func storiesForInteractiveReload(feedID: String) -> [HNStory]? {
        let defaults = UserDefaults.standard
        let reloadKey = interactiveReloadKey(for: feedID)
        guard defaults.bool(forKey: reloadKey) else { return nil }
        defaults.removeObject(forKey: reloadKey)
        guard let data = defaults.data(forKey: storiesKey(for: feedID)) else { return nil }
        return try? JSONDecoder().decode([HNStory].self, from: data)
    }

    static func markInteractiveReload(feedID: String) {
        UserDefaults.standard.set(true, forKey: interactiveReloadKey(for: feedID))
    }

    static func select(page: Int, feedID: String, pageSize: Int) {
        UserDefaults.standard.set(max(0, page), forKey: indexKey(for: feedID, pageSize: pageSize))
    }
}

struct NavigateStoryIntent: AppIntent {
    static let title: LocalizedStringResource = "Navigate Hacker News Stories"
    static let description = IntentDescription("Move to another Hacker News story in the widget.")

    @Parameter(title: "Feed")
    var feedID: String

    @Parameter(title: "Direction")
    var direction: Int

    @Parameter(title: "Story count")
    var storyCount: Int

    @Parameter(title: "Page size")
    var pageSize: Int

    @Parameter(title: "Maximum page")
    var maxPageIndex: Int

    init() {}

    init(feedID: String, direction: Int, storyCount: Int, pageSize: Int, maxPageIndex: Int) {
        self.feedID = feedID
        self.direction = direction
        self.storyCount = storyCount
        self.pageSize = pageSize
        self.maxPageIndex = maxPageIndex
    }

    func perform() async throws -> some IntentResult {
        guard storyCount > 0 else { return .result() }

        let currentPage = await WidgetStorySelection.currentPage(
            feedID: feedID,
            pageSize: pageSize,
            maxPageIndex: maxPageIndex
        )
        let nextPage = min(max(currentPage + direction, 0), max(0, maxPageIndex))
        await WidgetStorySelection.select(page: nextPage, feedID: feedID, pageSize: pageSize)
        await WidgetStorySelection.markInteractiveReload(feedID: feedID)
        return .result()
    }
}

enum Redirect: String, CaseIterable, AppEnum {
    case story = "story"
    case hn = "hn"

    static var caseDisplayRepresentations: [Redirect: DisplayRepresentation] {
        [
            .story: "Original Story",
            .hn: "Hacker News Discussion",
        ]
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Redirect")
    }
}

enum UpdateEveryIntent: Int, AppEnum {
    case five = 5
    case ten = 10
    case fifteen = 15
    case thirty = 30
    case sixty = 60

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Update every")
    }

    static var caseDisplayRepresentations: [UpdateEveryIntent : DisplayRepresentation] {
        [.five: "5 minutes", .ten: "10 minutes", .fifteen: "15 minutes", .thirty: "30 minutes", .sixty: "60 minutes"]
    }
}

