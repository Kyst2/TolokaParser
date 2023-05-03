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
        
        let animeUrls = ["https://toloka.to/t667640", "https://toloka.to/t667737", "https://toloka.to/t667517","https://toloka.to/t667787","https://toloka.to/t665667","https://toloka.to/t81059","https://toloka.to/t665320"]
        
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
            .value: "85c53b7dfadd95e904969e3d76bd8ad8",
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
        let title = try self.select("title").first()?.text()
        
        let matches = title?.matches(forRegex: #"^(.*?)\s(/|\s\()"#) ?? []
//                                        "([А-Я]|[а-я]|\\d|[:,іґїІҐЇ ])*/") ?? []
        
        let ukrTitle = matches.first?.trimmingCharacters(in: [" ", "/"])
        
        return ukrTitle
    }
    
    func getTitleJap() throws -> String? {
        try self.select("title").first()?.text()
    }
    
    //Kyst
    func getStudios() throws -> [String] {
        guard let postBody = try self.getElementsByClass("postbody").compactMap({ try? $0.text() }).first else { return [] }
        var firstMatch = postBody.matches(forRegex: "Кінокомпанія:[\\S\\s]*Режисер:").first
        var secondMatch = postBody.matches(forRegex: "Кіностудія / кінокомпанія:[\\S\\s]*Режисер:").first
        var thirdMatch = postBody.matches(forRegex: "Аніме-студія:[\\S\\s]*Режисер:").first
        var studios:[String] = []
        
        firstMatch = firstMatch?.replace(of: "Режисер:", to: " ").replace(of: "Кінокомпанія:", to: "").trimmingCharacters(in: ["\n", " ", "\t"])
        studios.append(firstMatch ?? "")
        secondMatch = secondMatch?.replace(of: "Режисер:", to: " ").replace(of: "Кіностудія / кінокомпанія:", to: "").trimmingCharacters(in: ["\n", " ", "\t"])
        studios.append(secondMatch ?? "")
        thirdMatch = thirdMatch?.replace(of: "Режисер:", to: " ").replace(of: "Аніме-студія:", to: "").trimmingCharacters(in: ["\n", " ", "\t"])
        studios.append(thirdMatch ?? "")

        return studios.filter({$0 != ""})
    }
    
    func getYear() throws -> Int {
        let title = try self.select("title").first()?.text()
        
        let matches = title?.matches(forRegex: "\\d{4}") ?? []
        
        let years = matches.compactMap{ Int($0) }.filter{ $0 > 1940 }
        
        return years.first ?? -1
    }
    
    //Kyst
    func getGenres() throws -> [String]? {
        guard let postBody = try self.getElementsByClass("postbody").compactMap({ try? $0.text() }).first,
              var firstMatch = postBody.matches(forRegex: "Жанр:[\\S\\s]*Країна:").first
        else { return nil }
        var genres:[String] = []
        
        firstMatch = firstMatch.replace(of: "Жанр:", to: "").replace(of: "Країна:", to: "").trimmingCharacters(in: ["\n", " ", "\t"])
        genres.append(firstMatch)
        
        return genres
    }
    
    func getDescr() throws -> String? {
        guard let postBody = try self.getElementsByClass("postbody").compactMap({ try? $0.text() }).first,
              let firstMatch = postBody.matches(forRegex: "Сюжет:[\\S\\s]*Тривалість:").first
        else { return nil }
        var descr = firstMatch
        
        descr = descr.replace(of: "Тривалість:", to: "").replace(of: "Сюжет:", to: "").trimmingCharacters(in: ["\n", " ", "\t"])
        
        return descr
    }
}
