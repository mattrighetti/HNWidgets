//
//  Provider.swift
//  HNWidgetExtension
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let links: [HNLink]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, links: [
            HNLink(id: 134, title: "Title", url: "", username: "mattrighetti", comments: 3234, upvotes: 22, elapsed: "2 hours ago"),
            HNLink(id: 133, title: "Title", url: "", username: "mattrighetti", comments: 3234, upvotes: 22, elapsed: "2 hours ago")
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let links = try! await HNPageFetcher.shared.getHNLinks()
            let entry = SimpleEntry(date: .now, links: links)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            let links = try! await HNPageFetcher.shared.getHNLinks()
            let entry = SimpleEntry(date: .now, links: links)

            let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 60 * 5)))
            completion(timeline)
        }
    }
}
