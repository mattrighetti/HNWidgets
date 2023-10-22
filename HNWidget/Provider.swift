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
    let links: [HNLink]
    let list: String
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, links: [
            HNLink(id: "134", title: "Title", url: "", username: "mattrighetti", comments: "3234", upvotes: "22", elapsed: "2 hours ago"),
            HNLink(id: "133", title: "Title", url: "", username: "mattrighetti", comments: "3234", upvotes: "22", elapsed: "2 hours ago")
        ], list: "home")
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        if case .success(let links) = try? await HNPageFetcher.shared.getHNLinks(from: configuration.list) {
            return SimpleEntry(date: .now, links: links, list: configuration.list.rawValue)
        }
        return SimpleEntry(date: .now, links: [], list: configuration.list.rawValue)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        if case .success(let links) = try? await HNPageFetcher.shared.getHNLinks(from: configuration.list) {
            let entry = SimpleEntry(date: .now, links: links, list: configuration.list.rawValue)
            
            let reloadDate = Calendar.current.date(byAdding: .minute, value: configuration.reload.rawValue, to: .now)!
            return Timeline(entries: [entry], policy: .after(reloadDate))
        }
        return Timeline(entries: [], policy: .after(.now.advanced(by: 60)))
    }
}
