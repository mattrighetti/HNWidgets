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

    var elapsedTime: String {
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - time

        switch timeDifference {
        case 0..<60:
            return "Just now"
        case 60..<120:
            return "1 minute ago"
        case 120..<3600:
            let minutes = Int(timeDifference / 60)
            return "\(minutes) minutes ago"
        case 3600..<7200:
            return "1 hour ago"
        case 7200..<86400:
            let hours = Int(timeDifference / 3600)
            return "\(hours) hours ago"
        case 86400..<172800:
            return "1 day ago"
        default:
            let days = Int(timeDifference / 86400)
            return "\(days) days ago"
        }
    }
}
