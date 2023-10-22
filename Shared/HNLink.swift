//
//  File.swift
//  
//
//  Created by Mattia Righetti on 21/10/23.
//

import Foundation

public struct HNLink: Identifiable, Hashable, Equatable {
    public let id: String
    public let title: String
    public let url: String
    public let username: String?
    public let comments: String?
    public let upvotes: String?
    public let elapsed: String?
}
