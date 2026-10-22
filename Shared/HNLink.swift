//
//  File.swift
//  
//
//  Created by Mattia Righetti on 21/10/23.
//

import Foundation

struct HNStory: Identifiable, Hashable, Codable, Sendable {
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
        Date(timeIntervalSince1970: time).formatted(.relative(presentation: .named))
    }
}
