//
//  File.swift
//  
//
//  Created by Mattia Righetti on 21/10/23.
//

import Kanna

public enum Datum {
    case Athing(id: String, innerHtml: XMLElement, sub: XMLElement)
}

public class HTMLParser {
    private let document: HTMLDocument

    public init?(html: String) {
        guard let document = try? Kanna.HTML(html: html, encoding: .utf8) else { return nil }
        self.document = document
    }

    public func getElements() -> [Datum] {
        guard
            let titles = document.body?.xpath("//tr[contains(@class, 'athing')]"),
            let sub = document.body?.xpath("//td[contains(@class, 'subtext')]")
        else { return [] }

        var data = [Datum]()
        for (elem, sub) in zip(titles, sub) {
            guard let id = elem["id"] else { continue }
            data.append(Datum.Athing(id: id, innerHtml: elem, sub: sub))
        }

        return data
    }

    private func getHNLink(_ obj: Datum) -> HNLink? {
        if case .Athing(let id, let innerHtml, let sub) = obj {
            guard
                let header = innerHtml.xpath("//td[@class='title']//a[1]").first,
                let title = header.text,
                let url = header["href"]
            else { return nil }

            let username = sub.xpath("//a[@class='hnuser']").first?.text
            let age = sub.xpath("//span[@class='age']//a").first?.text
            let score = sub.xpath("//span[@class='score']").first?.text?.leaveNumbers
            let comments = sub.xpath("//a[contains(text(), 'comments')]").first?.text?.leaveNumbers

            return HNLink(id: id, title: title, url: url, username: username, comments: comments, upvotes: score, elapsed: age)
        }

        return nil
    }

    public func getHNLinks() -> [HNLink] {
        getElements()
            .compactMap { x in
                getHNLink(x)
            }
    }
}

extension String {
    var leaveNumbers: String {
        self.trimmingCharacters(in: .letters).trimmingCharacters(in: .whitespaces)
    }
}
