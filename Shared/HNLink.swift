//
//  File.swift
//  
//
//  Created by Mattia Righetti on 21/10/23.
//

import Foundation

public struct HNLink: Identifiable, Hashable, Equatable {
    public let id: Int
    public let title: String
    public let url: String
    public let username: String
    public let comments: Int
    public let upvotes: Int
    public let elapsed: String
}
