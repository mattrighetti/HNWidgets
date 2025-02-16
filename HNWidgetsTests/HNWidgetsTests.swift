//
//  HNWidgetsTests.swift
//  HNWidgetsTests
//
//  Created by Mattia Righetti on 2/16/25.
//

import XCTest
import HNWidgets

final class HNWidgetsTests: XCTestCase {
    func testFetchAndParseHNMainPage() async throws {
        // Step 1: Fetch HTML from HN main page
        let url = URL(string: "https://news.ycombinator.com")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let html = String(data: data, encoding: .utf8)!

        // Step 2: Initialize HTMLParser
        guard let parser = HTMLParser(html: html) else {
            XCTFail("Failed to initialize HTMLParser")
            return
        }

        // Step 3: Validate parsed elements
        let elements = parser.getElements()
        XCTAssertFalse(elements.isEmpty, "No elements were parsed from the HTML")

        // Step 4: Validate parsed HN links
        let hnLinks = parser.getHNLinks()
        XCTAssertFalse(hnLinks.isEmpty, "No HN links were parsed from the HTML")

        // Step 5: Validate the content of the first HN link
        if let firstLink = hnLinks.first {
            XCTAssertFalse(firstLink.title.isEmpty, "The title of the first link should not be empty")
            XCTAssertFalse(firstLink.url.isEmpty, "The URL of the first link should not be empty")
        } else {
            XCTFail("The parsed HN links array is empty")
        }
    }
}
