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
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("HN Widgets")
        .description("View latest Hacker News")
    }
}

#Preview(as: .systemMedium) {
    HNWidget()
} timeline: {
    SimpleEntry(date: .now, list: "home", stories: [
        HNStory(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", by: "AndrewDucker", score: 23, time: Date().timeIntervalSince1970 - 27 * 60),
        HNStory(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", by: "Anon84", score: 80, time: Date().timeIntervalSince1970 - 60 * 60),
        HNStory(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", by: "laurex", score: 11, time: Date().timeIntervalSince1970 - 20 * 60),
        HNStory(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", by: "AndrewDucker", score: 23, time: Date().timeIntervalSince1970 - 27 * 60),
        HNStory(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", by: "Anon84", score: 80, time: Date().timeIntervalSince1970 - 60 * 60),
        HNStory(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", by: "laurex", score: 11, time: Date().timeIntervalSince1970 - 20 * 60),
        HNStory(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", by: "laurex", score: 11, time: Date().timeIntervalSince1970 - 20 * 60),
        HNStory(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", by: "AndrewDucker", score: 23, time: Date().timeIntervalSince1970 - 27 * 60),
        HNStory(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", by: "Anon84", score: 80, time: Date().timeIntervalSince1970 - 60 * 60),
        HNStory(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", by: "laurex", score: 11, time: Date().timeIntervalSince1970 - 20 * 60),
        HNStory(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", by: "AndrewDucker", score: 23, time: Date().timeIntervalSince1970 - 27 * 60),
        HNStory(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", by: "Anon84", score: 80, time: Date().timeIntervalSince1970 - 60 * 60),
        HNStory(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", by: "laurex", score: 11, time: Date().timeIntervalSince1970 - 20 * 60),
        HNStory(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", by: "laurex", score: 11, time: Date().timeIntervalSince1970 - 20 * 60)
    ])
}
