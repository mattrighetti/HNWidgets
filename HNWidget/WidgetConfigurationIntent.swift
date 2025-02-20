//
//  WidgetConfigurationIntent.swift
//  HNWidgetExtension
//
//  Created by Mattia Righetti on 22/10/23.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select List"
    static var description = IntentDescription("Select HN List to fetch links from")

    @Parameter(title: "Update every", default: .five)
    var reload: UpdateEveryIntent

    @Parameter(title: "List", default: .home)
    var list: HackerNewsService.HNList
}

enum UpdateEveryIntent: Int, AppEnum {
    case five = 5
    case ten = 10
    case fifteen = 15
    case thirty = 30
    case sixty = 60

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Update every")
    }

    static var caseDisplayRepresentations: [UpdateEveryIntent : DisplayRepresentation] {
        [.five: "5 minutes", .ten: "10 minutes", .fifteen: "15 minutes", .thirty: "30 minutes", .sixty: "60 minutes"]
    }
}

