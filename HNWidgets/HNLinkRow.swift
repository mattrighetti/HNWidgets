//
//  HNLinkRow.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI

struct HNLinkRow: View {
    var link: HNStory
    var titleLineLimit = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(link.title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .padding(.bottom, 0)
                .lineLimit(titleLineLimit)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 9, weight: .semibold))

                Text("\(link.score)")

                Text("· \(link.elapsedTime)")
            }
            .font(.system(size: 11, weight: .regular))
            .foregroundStyle(.secondary)
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
