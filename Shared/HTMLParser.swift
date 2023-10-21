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
            let titles = document.body?.xpath("//tr[@class='athing']"),
            let sub = document.body?.xpath("//td[@class='subtext']")
        else { return [] }

        var data = [Datum]()
        for (t, s) in zip(titles, sub) {
            data.append(Datum.Athing(id: t["id"]!, innerHtml: t, sub: s))
        }

        return data
    }

    private func getHNLink(_ obj: Datum) -> HNLink? {
        if case .Athing(let id, let innerHtml, let sub) = obj {
            print(id)
            let header = innerHtml.xpath("//td[@class='title']//a[1]").first!
            let title = header.text
            let url = header["href"]

            let username = sub.xpath("//a[@class='hnuser']").first?.text
            let age = sub.xpath("//span[@class='age']//a").first!.text
            let score = sub.xpath("//span[@class='score']").first?.text!.trimmingCharacters(in: .letters).trimmingCharacters(in: .whitespaces)
            let comments = sub.xpath("//a[contains(text(), 'comments')]").first?.text!.trimmingCharacters(in: .letters).trimmingCharacters(in: .whitespaces)
            return HNLink(id: Int(id)!, title: title!, url: url!, username: username ?? "", comments: comments != nil ? Int(comments!)! : 0, upvotes: score != nil ? Int(score!)! : 0, elapsed: age!)
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
