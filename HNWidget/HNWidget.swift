//
//  HNWidget.swift
//  HNWidget
//
//  Created by Mattia Righetti on 21/10/23.
//

import WidgetKit
import SwiftUI

struct HNWidget: Widget {
    let kind: String = "HNWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HNWidgetEntryView(entry: entry)
                    .containerBackground(.fill.quinary, for: .widget)
            } else {
                HNWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge, .accessoryRectangular])
        .configurationDisplayName("HN Widgets")
        .description("View latest Hacker News stories")
    }
}

private let previewEntry = SimpleEntry(
    date: .now,
    list: "Top Stories",
    feedID: "topstories",
    redirect: .story,
    stories: (1...30).map { number in
        HNStory(
            id: 37967000 + number,
            title: "Example Hacker News story number \(number)",
            url: "https://example.com/story-\(number)",
            by: "swiftcoder",
            score: 23 + number,
            time: Date().timeIntervalSince1970 - Double(number * 60)
        )
    },
    selectedStoryPage: 0
)

#Preview(as: .systemMedium) {
    HNWidget()
} timeline: {
    previewEntry
}

#Preview(as: .systemLarge) {
    HNWidget()
} timeline: {
    previewEntry
}

#Preview(as: .systemExtraLarge) {
    HNWidget()
} timeline: {
    previewEntry
}

#Preview(as: .accessoryRectangular) {
    HNWidget()
} timeline: {
    previewEntry
}
