//
//  HNWidgetEntryView.swift
//  HNWidgetExtension
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI
import WidgetKit

struct Constants {
    static let titleFontSize: CGFloat = 20
    static let listFontSize: CGFloat = 13
    static let defaultPadding: CGFloat = 8
    static let linkSpacing: CGFloat = 4
}

@ViewBuilder
private func HeaderView(title: String, list: String) -> some View {
    HStack(alignment: .center) {
        Text(title)
            .font(.system(size: Constants.titleFontSize, weight: .bold))
            .foregroundStyle(.orange)
            .accessibilityLabel("Hacker News title")
        Text(list)
            .font(.system(size: Constants.listFontSize, weight: .light))
            .foregroundStyle(.gray)
            .accessibilityLabel("Story list type")
    }
}

@ViewBuilder
private func StoriesView(stories: [HNStory], redirect: Redirect) -> some View {
    VStack(alignment: .leading, spacing: Constants.linkSpacing) {
        ForEach(stories) { story in
            LinkRowView(story: story, redirect: redirect)
        }
    }
}

@ViewBuilder
private func LinkRowView(story: HNStory, redirect: Redirect) -> some View {
    let destinationURL = redirect == .hn ? story.hnUrl : story.url
    if let urlString = destinationURL, let url = URL(string: "hnwidgets://openlink?link=\(urlString)") {
        Link(destination: url) {
            HNLinkRow(link: story)
                .accessibilityLabel("Link to \(story.title)")
        }
    } else {
        HNLinkRow(link: story)
            .accessibilityLabel("Link unavailable for \(story.title)")
    }
}

struct HNWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: SimpleEntry

    var limit: Int {
        switch widgetFamily {
        case .systemSmall:
            return 0
        case .systemMedium:
            return 3
        case .systemLarge, .systemExtraLarge:
            return 7
        default:
            return 0
        }
    }

    var spacing: (Double, Double, Double) {
        switch widgetFamily {
        case .systemMedium:
            return (2,0.2,0.2)
        case .systemExtraLarge, .systemLarge:
            return (0,5,5)
        default:
            return (0,0,0)
        }
    }

    var body: some View {
        if entry.showError {
            Text("Failed to load Hacker News data")
                .foregroundStyle(.red)
                .accessibilityLabel("Error loading data")
        } else if entry.stories.isEmpty {
            Text("No stories available")
                .foregroundStyle(.gray)
                .accessibilityLabel("No stories available")
        } else {
            VStack(alignment: .leading, spacing: Constants.defaultPadding) {
                HeaderView(title: "Hacker News", list: entry.list)
                StoriesView(stories: Array(entry.stories.prefix(limit)), redirect: entry.redirect)
            }
        }
    }
}


