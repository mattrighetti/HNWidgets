//
//  HNLinkRow.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI

struct HNLinkRow: View {
    @Environment(\.openURL) var openURL

    var link: HNStory
    var lineLimit: Int = 3

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(link.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .padding(.bottom, 0)
                    .lineLimit(lineLimit)

                Text("\(link.score) points by \(link.by) \(link.elapsedTime)")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

#Preview {
    HNLinkRow(link: HNStory(
        id: 12345678,
        title: "Example Hacker News Story",
        url: "https://example.com",
        by: "swiftcoder",
        score: 256,
        time: 1698765432
    ))
}
