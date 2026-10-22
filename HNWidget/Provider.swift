//
//  Provider.swift
//  HNWidgetExtension
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI
import AppIntents
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let list: String
    let feedID: String
    let redirect: Redirect
    let stories: [HNStory]
    let selectedStoryPage: Int
}

struct Provider: AppIntentTimelineProvider {
    private let storyLimit = 30

    private func stories(for configuration: ConfigurationAppIntent) async throws -> [HNStory] {
        if let cachedStories = await WidgetStorySelection.storiesForInteractiveReload(
            feedID: configuration.list.rawValue
        ) {
            return cachedStories
        }

        let stories = try await HackerNewsService.shared.fetchStories(
            for: configuration.list,
            limit: storyLimit
        )
        await WidgetStorySelection.cache(stories, feedID: configuration.list.rawValue)
        return stories
    }

    private func pageSize(for family: WidgetFamily) -> Int? {
        switch family {
        case .systemMedium:
            return Constants.mediumWidgetStoryCount
        case .systemLarge:
            return Constants.largeWidgetStoryCount
        default:
            return nil
        }
    }

    private func maxPageIndex(for family: WidgetFamily, storyCount: Int) -> Int {
        guard let pageSize = pageSize(for: family) else { return 0 }
        let pageCount = (storyCount + pageSize - 1) / pageSize
        return max(0, pageCount - 1)
    }

    // MARK: - Placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: .now,
            list: HackerNewsService.HNList.home.displayName,
            feedID: HackerNewsService.HNList.home.rawValue,
            redirect: .story,
            stories: [
                HNStory(id: 134, title: "Title", url: "", by: "mattrighetti", score: 22, time: 1000),
                HNStory(id: 133, title: "Title", url: "", by: "mattrighetti", score: 22, time: 1111)
            ],
            selectedStoryPage: 0
        )
    }

    // MARK: - Snapshot
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let stories = try await stories(for: configuration)
            return SimpleEntry(
                date: .now,
                list: configuration.list.displayName,
                feedID: configuration.list.rawValue,
                redirect: configuration.redirectTo,
                stories: stories,
                selectedStoryPage: await WidgetStorySelection.currentPage(
                    feedID: configuration.list.rawValue,
                    pageSize: pageSize(for: context.family) ?? storyLimit,
                    maxPageIndex: maxPageIndex(for: context.family, storyCount: stories.count)
                )
            )
        } catch {
            // Fallback to placeholder data in case of error
            return SimpleEntry(
                date: .now,
                list: configuration.list.displayName,
                feedID: configuration.list.rawValue,
                redirect: configuration.redirectTo,
                stories: [],
                selectedStoryPage: 0
            )
        }
    }

    // MARK: - Timeline
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        do {
            let stories = try await stories(for: configuration)
            let entry = SimpleEntry(
                date: .now,
                list: configuration.list.displayName,
                feedID: configuration.list.rawValue,
                redirect: configuration.redirectTo,
                stories: stories,
                selectedStoryPage: await WidgetStorySelection.currentPage(
                    feedID: configuration.list.rawValue,
                    pageSize: pageSize(for: context.family) ?? storyLimit,
                    maxPageIndex: maxPageIndex(for: context.family, storyCount: stories.count)
                )
            )

            // Calculate the reload date based on configuration
            let reloadDate = Date.now.addingTimeInterval(TimeInterval(configuration.reload.rawValue * 60))
            return Timeline(entries: [entry], policy: .after(reloadDate))
        } catch {
            // On failure show the error state and retry after 1 minute
            let fallbackEntry = SimpleEntry(
                date: .now,
                list: configuration.list.displayName,
                feedID: configuration.list.rawValue,
                redirect: configuration.redirectTo,
                stories: [],
                selectedStoryPage: 0
            )
            let retryDate = Date.now.addingTimeInterval(60)
            return Timeline(entries: [fallbackEntry], policy: .after(retryDate))
        }
    }
}
