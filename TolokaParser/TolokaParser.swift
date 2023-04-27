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
        
//        let allPages = getAllPages(fromCategory: "https://toloka.to/f127")
        
//        let animeUrls = allPages.map{ parseAnimeTopicsUrlsFrom($0) }.flatMap{ $0 }
        
        let animeUrls = ["https://toloka.to/t667640", "https://toloka.to/t667737", "https://toloka.to/t667517","https://toloka.to/t667787","https://toloka.to/t665667","https://toloka.to/t81059"]
        
        let animes = animeUrls.map { extractAnimeData(from: $0) }
        
        print("finished")
    }
    
}

///////////////////////////////
// Get anime urls
///////////////////////////////
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
    
    static func getAllPages(fromCategory categoryUrl: String) -> [String] {
        var pagesWithAnimeLists:[String] = []
        
        var pageNum = 0
        var needParsePageOneMoreTime = false
        
        while true {
            let anumeNum = pageNum * 90
            
            guard let pageLink = URL(string: "\(categoryUrl)-\(anumeNum)") else { fatalError("Invalid URL") }
            
            do {
                let htmlPage = try String(contentsOf: pageLink)
                let doc: Document = try! SwiftSoup.parse(htmlPage)
                
                guard try doc.isPageLoaded() else { needParsePageOneMoreTime = true; break }
                
                if try doc.isFinalPageDisplayed() { break }
                
                pagesWithAnimeLists.append("\(categoryUrl)-\(anumeNum)")
            } catch {
                print("Error")
            }
            
            if !needParsePageOneMoreTime {
                pageNum+=1
            }
            needParsePageOneMoreTime = false
        }
        
        return pagesWithAnimeLists
    }
    
//    static func getAllAnimeUrls(fromCategory categoryUrl: String) -> [String] {
//        var allAnimeLinks:[String] = []
//
//        var pageNum = 0
//
//        while true {
//            let anumeNum = pageNum * 90
//
//            let animeLinks = parseAnimeTopicsUrlsFrom("\(categoryUrl)-\(anumeNum)")
//
//            if animeLinks.isEmpty { break }
//
//            allAnimeLinks.append(contentsOf: animeLinks)
//
//            pageNum+=1
//        }
//
//        return allAnimeLinks
//    }
    
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

///////////////////////////////
// Get "Anime" items
///////////////////////////////
fileprivate extension TolokaParser {
    static func extractAnimeData(from url: String) -> Anime? {
        guard  let url = URL(string: url) else { return nil }
        
        do {
            let html = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(html)
            
            let titleEng = try doc.getTitleEng()
            let titleJap = try doc.getTitleJap()
            let titleUkr = try doc.getTitleUkr()
            
            let studios  = try doc.getStudios()//Кінокомпанія: / Кіностудія / Аніме-студія
            let year     = try doc.getYear()   // get from title
            let genres   = try doc.getGenres() //Жанр:
            let descr    = try doc.getDescr()  //Сюжет:
            
//            anime.nameUkr = title
            //            let studio = try doc.select("<tr><td colspan=\"2\" style=\"padding: 6px; border-top: 1px solid #ADBAC6;">").first()
            //                .compactMap { try? $0.attr("Кінокомпанія:") }
            ////            }
            ///
            
            return Anime( nameJap: titleJap, nameEng: titleEng, nameUkr: titleUkr, studios: studios,
                               year: year, genres: genres, descr: descr, urlsDetails: [] )
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
}

////////////////////////
///HELPERS
///////////////////////

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
            .value: "b00906a812106edbb03e32a4b52b437cс",
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

fileprivate extension Document {
    func isFinalPageDisplayed() throws -> Bool {
        try self.getElementsContainingOwnText("У цьому форумі немає повідомлень.").count > 0
    }
    
    func isPageLoaded() throws -> Bool {
        try self.getElementsContainingOwnText("Профіль").count > 0
    }
}

////////////////////////
///Anime page HELPERS
///////////////////////
fileprivate extension Document {
    func getTitleEng() throws -> String? {
        try self.select("title").first()?.text()
    }
    
    func getTitleUkr() throws -> String? {
        try self.select("title").first()?.text()
    }
    
    func getTitleJap() throws -> String? {
        try self.select("title").first()?.text()
    }
    
    func getStudios() throws -> [String] {
        return []
    }
    
    func getYear() throws -> Int {
        let title = try self.select("title").first()?.text()
        
        var matches = title?.matches(forRegex: "\\d\\d\\d\\d") ?? []
        
        let years = matches.compactMap{ Int($0) }.filter{ $0 > 1940 }
        
        return years.first ?? -1
    }
    func getGenres() throws -> [String] {
        return []
    }
    
    func getDescr() throws -> String? {
        return ""
    }
}

extension String {
    func matches(forRegex regex: String) -> [String] {
        let text = self
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
