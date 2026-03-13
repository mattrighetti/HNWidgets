//
//  File.swift
//  
//
//  Created by Mattia Righetti on 21/10/23.
//

import Foundation

struct HNStory: Identifiable, Hashable, Equatable, Codable {
    let id: Int
    let title: String
    let url: String?
    let by: String
    let score: Int
    let time: TimeInterval
    var hnUrl: String {
        "https://news.ycombinator.com/item?id=\(id)"
    }

    var elapsedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: Date(timeIntervalSince1970: time), relativeTo: .now)
    }
}
