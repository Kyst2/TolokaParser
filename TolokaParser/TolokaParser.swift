//
//  TolokaParser.swift
//  TolokaParser
//
//  Created by Andrew Kuzmich on 25.04.2023.
//

import Foundation
import SwiftSoup

class TolokaParser {
    static func parse() {
        login()
        
        let animeUrlsFromAllPages = getAllAnimeUrls(fromCategory: "https://toloka.to/f127")
        
        print("finished")
    }
}

fileprivate extension TolokaParser {
    static func login() {
        guard let url = URL(string: "https://toloka.to/f127") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Make the request using URLSession
        let session = URLSession.shared
        
        let cookies11 = getCookies()
        
        for c in cookies11 {
            session.configuration.httpCookieStorage?.setCookie(c)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
    //        let resp = String(data: data, encoding: .utf8)
    //        print(resp!)
        }
        
        task.resume()
    }
    
    static func getAllAnimeUrls(fromCategory categoryUrl: String) -> [String] {
        var allAnimeLinks:[String] = []
        
        var pageNum = 0
        
        while true {
            let anumeNum = pageNum * 90
            
            let animeLinks = parseAnimeTopicsUrlsFrom("\(categoryUrl)-\(anumeNum)")
            
            if animeLinks.isEmpty { break }
            
            allAnimeLinks.append(contentsOf: animeLinks)
            
            pageNum+=1
        }
        
        return allAnimeLinks
    }
    
    static func parseAnimeTopicsUrlsFrom (_ url:String) -> [String] {
        guard let url = URL(string: url) else { fatalError("Invalid URL") }
        
        do {
            let html = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(html)
            
            return try doc.select("a.topictitle")
                .compactMap { try? $0.attr("href") }
                .map{ "https://toloka.to/\($0)" }
        } catch {
            print("Error: \(error)")
        }
        
        return []
    }
}

fileprivate func getCookies() -> [HTTPCookie] {
    return [
        HTTPCookie(properties: [
            .name: "toloka_data",
            .value: "a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%221cc3e9d3c154a5b2a6b7b6495fb73d4f%22%3Bs%3A6%3A%22userid%22%3Bi%3A1188862%3B%7D",
            .domain: "toloka.to",
            .path: "/",
            .expires: Date(timeIntervalSinceNow: 10),
            .comment: ""
        ])!,
        
        HTTPCookie(properties: [
            .name: "toloka_sid",
            .value: "08e0895f28c06f713b4573b29e7fce4a",
            .domain: "toloka.to",
            .path: "/",
            .expires: Date(timeIntervalSinceNow: 10),
            .comment: ""
        ])!,
        
        HTTPCookie(properties: [
            .name: "toloka_ssl",
            .value: "1",
            .domain: "toloka.to",
            .path: "/",
            .expires: Date(timeIntervalSinceNow: 10),
            .comment: ""
        ])!,
    ]
}
