//
//  HNLinkRow.swift
//  HNWidgets
//
//  Created by Mattia Righetti on 21/10/23.
//

import SwiftUI

struct HNLinkRow: View {
    @Environment(\.openURL) var openURL

    var link: HNLink

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(link.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .padding(.bottom, 0)
                    .lineLimit(1)

                Text("\(link.upvotes) points by \(link.username) \(link.elapsed)")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

#Preview {
    HNLinkRow(link: HNLink(id: 123, title: "Tesorio (YC S15) Is Hiring a Sr Data Engineer and Sr Back End Engineer in Latam", url: "", username: "mattrighetti", comments: 3, upvotes: 3329, elapsed: "1 hour ago"))
}
