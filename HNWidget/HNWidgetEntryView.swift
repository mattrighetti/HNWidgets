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
    static let mediumWidgetStoryCount = 2
    static let largeWidgetStoryCount = 6
}

@ViewBuilder
@MainActor
private func HeaderView(title: String, list: String) -> some View {
    HStack(alignment: .center) {
        if #available(iOSApplicationExtension 18.0, *) {
            Text(title)
                .font(.system(size: Constants.titleFontSize, weight: .bold))
                .foregroundStyle(.orange)
                .widgetAccentable()
                .accessibilityLabel("Hacker News title")
        } else {
            Text(title)
                .font(.system(size: Constants.titleFontSize, weight: .bold))
                .foregroundStyle(.orange)
                .accessibilityLabel("Hacker News title")
        }
        Text(list)
            .font(.system(size: Constants.listFontSize, weight: .light))
            .foregroundStyle(.gray)
            .accessibilityLabel("Story list type")
    }
}

@ViewBuilder
@MainActor
private func StoriesView(stories: [HNStory], redirect: Redirect, titleLineLimit: Int = 3) -> some View {
    VStack(alignment: .leading, spacing: Constants.linkSpacing) {
        ForEach(stories) { story in
            LinkRowView(story: story, redirect: redirect, titleLineLimit: titleLineLimit)
        }
    }
}

@ViewBuilder
@MainActor
private func LinkRowView(story: HNStory, redirect: Redirect, titleLineLimit: Int) -> some View {
    if let destination = widgetDestinationURL(for: story, redirect: redirect) {
        Link(destination: destination) {
            HNLinkRow(link: story, titleLineLimit: titleLineLimit)
        }
        .accessibilityLabel("Link to \(story.title)")
    } else {
        HNLinkRow(link: story, titleLineLimit: titleLineLimit)
            .accessibilityLabel("Link unavailable for \(story.title)")
    }
}

private func widgetDestinationURL(for story: HNStory, redirect: Redirect) -> URL? {
    if redirect == .story, let destination = widgetDestinationURL(for: story.url) {
        return destination
    }
    // Text posts have no external URL; their discussion is still readable.
    return widgetDestinationURL(for: story.hnUrl)
}

private func widgetDestinationURL(for destination: String?) -> URL? {
    guard let destination,
          let components = URLComponents(string: destination),
          let scheme = components.scheme?.lowercased(),
          ["http", "https"].contains(scheme),
          components.host != nil else {
        return nil
    }
    return components.url
}

@ViewBuilder
@MainActor
private func AccessoryStoryView(story: HNStory, list: String, redirect: Redirect) -> some View {
    let label = VStack(alignment: .leading, spacing: 4) {
        Text(list.uppercased())
            .font(.system(.caption2, weight: .bold))
            .foregroundStyle(.orange)
        Text(story.title)
            .font(.system(.caption, weight: .semibold))
            .lineLimit(2)
        Text("★ \(story.score) · Hacker News")
            .font(.system(.caption2))
            .foregroundStyle(.secondary)
    }

    label
        .widgetURL(widgetDestinationURL(for: story, redirect: redirect))
        .accessibilityLabel("Open \(story.title)")
}

@ViewBuilder
@MainActor
private func PagedStoriesView(
    entry: SimpleEntry,
    visibleCount: Int,
    titleLineLimit: Int,
    topPadding: CGFloat
) -> some View {
    let pageCount = (entry.stories.count + visibleCount - 1) / visibleCount
    let maxPageIndex = max(0, pageCount - 1)
    let pageIndex = min(entry.selectedStoryPage, maxPageIndex)
    let storyOffset = pageIndex * visibleCount
    let visibleStories = Array(entry.stories.dropFirst(storyOffset).prefix(visibleCount))

    VStack(alignment: .leading, spacing: Constants.defaultPadding) {
        HeaderView(title: "Hacker News", list: entry.list)
        StoriesView(stories: visibleStories, redirect: entry.redirect, titleLineLimit: titleLineLimit)
        Spacer(minLength: 0)
        HStack {
            if pageIndex > 0 {
                Button(intent: NavigateStoryIntent(
                    feedID: entry.feedID,
                    direction: -1,
                    storyCount: entry.stories.count,
                    pageSize: visibleCount,
                    maxPageIndex: maxPageIndex
                )) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 44, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Previous page of stories")
            } else {
                Color.clear
                    .frame(width: 44, height: 36)
                    .accessibilityHidden(true)
            }

            Spacer()
            Text("\(storyOffset + 1)–\(storyOffset + visibleStories.count) of \(entry.stories.count)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
            Spacer()

            if pageIndex < maxPageIndex {
                Button(intent: NavigateStoryIntent(
                    feedID: entry.feedID,
                    direction: 1,
                    storyCount: entry.stories.count,
                    pageSize: visibleCount,
                    maxPageIndex: maxPageIndex
                )) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 44, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Next page of stories")
            } else {
                Color.clear
                    .frame(width: 44, height: 36)
                    .accessibilityHidden(true)
            }
        }
        .foregroundStyle(.orange)
    }
    .padding(.top, topPadding)
}

struct HNWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: SimpleEntry

    var limit: Int {
        switch widgetFamily {
        case .accessoryRectangular:
            return 1
        case .systemMedium:
            return Constants.mediumWidgetStoryCount
        case .systemLarge:
            return Constants.largeWidgetStoryCount
        case .systemExtraLarge:
            return 10
        default:
            return 0
        }
    }

    var body: some View {
        if entry.stories.isEmpty {
            Label("Stories unavailable", systemImage: "wifi.slash")
                .foregroundStyle(.secondary)
                .font(.caption)
                .accessibilityLabel("Hacker News stories are unavailable. The widget will try again soon.")
        } else if widgetFamily == .accessoryRectangular {
            AccessoryStoryView(story: entry.stories[0], list: entry.list, redirect: entry.redirect)
        } else if widgetFamily == .systemMedium {
            PagedStoriesView(
                entry: entry,
                visibleCount: Constants.mediumWidgetStoryCount,
                titleLineLimit: 2,
                topPadding: 12
            )
        } else if widgetFamily == .systemLarge {
            PagedStoriesView(
                entry: entry,
                visibleCount: Constants.largeWidgetStoryCount,
                titleLineLimit: 3,
                topPadding: 8
            )
        } else {
            VStack(alignment: .leading, spacing: Constants.defaultPadding) {
                HeaderView(title: "Hacker News", list: entry.list)
                StoriesView(stories: Array(entry.stories.prefix(limit)), redirect: entry.redirect)
            }
        }
    }
}


