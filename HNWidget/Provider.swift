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
    let redirect: Redirect
    let stories: [HNStory]
}

struct Provider: AppIntentTimelineProvider {
    // MARK: - Placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: .now,
            list: "home",
            redirect: .story,
            stories: [
                HNStory(id: 134, title: "Title", url: "", by: "mattrighetti", score: 22, time: 1000),
                HNStory(id: 133, title: "Title", url: "", by: "mattrighetti", score: 22, time: 1111)
            ]
        )
    }

    // MARK: - Snapshot
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let stories = try await HackerNewsService.shared.fetchStories(for: configuration.list, limit: 10)
            return SimpleEntry(date: .now, list: configuration.list.rawValue, redirect: configuration.redirectTo, stories: stories)
        } catch {
            // Fallback to placeholder data in case of error
            return SimpleEntry(date: .now, list: configuration.list.rawValue, redirect: configuration.redirectTo, stories: [])
        }
    }

    // MARK: - Timeline
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        do {
            let stories = try await HackerNewsService.shared.fetchStories(for: configuration.list, limit: 10)
            let entry = SimpleEntry(date: .now, list: configuration.list.rawValue, redirect: configuration.redirectTo, stories: stories)

            // Calculate the reload date based on configuration
            let reloadDate = Calendar.current.date(byAdding: .minute, value: configuration.reload.rawValue, to: .now)!
            return Timeline(entries: [entry], policy: .after(reloadDate))
        } catch {
            // On failure show the error state and retry after 1 minute
            let fallbackEntry = SimpleEntry(
                date: .now,
                list: configuration.list.rawValue,
                redirect: configuration.redirectTo,
                stories: []
            )
            let retryDate = Calendar.current.date(byAdding: .minute, value: 1, to: .now)!
            return Timeline(entries: [fallbackEntry], policy: .after(retryDate))
        }
    }
}
