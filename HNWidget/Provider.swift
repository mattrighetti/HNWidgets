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
    let links: [HNLink]
    var showError: Bool {
        links.count == 0
    }
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, list: "home", links: [
            HNLink(id: "134", title: "Title", url: "", username: "mattrighetti", comments: "3234", upvotes: "22", elapsed: "2 hours ago"),
            HNLink(id: "133", title: "Title", url: "", username: "mattrighetti", comments: "3234", upvotes: "22", elapsed: "2 hours ago")
        ])
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        if case .success(let links) = await HNPageFetcher.shared.getHNLinks(from: configuration.list) {
            return SimpleEntry(date: .now, list: configuration.list.rawValue, links: links)
        }
        return SimpleEntry(date: .now, list: configuration.list.rawValue, links: [])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        if case .success(let links) = await HNPageFetcher.shared.getHNLinks(from: configuration.list) {
            let entry = SimpleEntry(date: .now, list: configuration.list.rawValue, links: links)
            let reloadDate = Calendar.current.date(byAdding: .minute, value: configuration.reload.rawValue, to: .now)!
            return Timeline(entries: [entry], policy: .after(reloadDate))
        }
        return Timeline(entries: [], policy: .after(.now.advanced(by: 60)))
    }
}
