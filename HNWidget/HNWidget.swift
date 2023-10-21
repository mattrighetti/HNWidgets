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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
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
    SimpleEntry(date: .now, links: [
        HNLink(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: 2, upvotes: 23, elapsed: "27 minutes ago"),
        HNLink(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: 15, upvotes: 80, elapsed: "1 hour ago"),
        HNLink(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: 3, upvotes: 11, elapsed: "20 minutes ago"),
        HNLink(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: 2, upvotes: 23, elapsed: "27 minutes ago"),
        HNLink(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: 15, upvotes: 80, elapsed: "1 hour ago"),
        HNLink(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: 3, upvotes: 11, elapsed: "20 minutes ago"),
        HNLink(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: 3, upvotes: 11, elapsed: "20 minutes ago"),
        HNLink(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: 2, upvotes: 23, elapsed: "27 minutes ago"),
        HNLink(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: 15, upvotes: 80, elapsed: "1 hour ago"),
        HNLink(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: 3, upvotes: 11, elapsed: "20 minutes ago"),
        HNLink(id: 37967936, title: "The Worlds First FPGA N64", url: "http://www.ultrafp64.com/", username: "AndrewDucker", comments: 2, upvotes: 23, elapsed: "27 minutes ago"),
        HNLink(id: 37967126, title: "What Every Developer Should Know About GPU Computing", url: "https://codeconfessions.substack.com/p/gpu-computing", username: "Anon84", comments: 15, upvotes: 80, elapsed: "1 hour ago"),
        HNLink(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: 3, upvotes: 11, elapsed: "20 minutes ago"),
        HNLink(id: 37967751, title: "The exam that broke society", url: "https://aeon.co/essays/why-chinese-minds-still-bear-the-long-shadow-of-keju", username: "laurex", comments: 3, upvotes: 11, elapsed: "20 minutes ago")
    ])
}
