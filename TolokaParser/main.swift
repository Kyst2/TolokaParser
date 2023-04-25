//
//  main.swift
//  TolokaParser
//
//  Created by Andrew Kuzmich on 24.03.2023.
//

import Foundation
import SwiftUI
import SwiftSoup

//makeRequest2()
//getAnime2()
//getAllLinks()
//getAnimeInfo()
//extractAnimeData()
//getAllLinks()
//getAnimeInfo(getAnime2())


TolokaParser.parse()

_ = readLine()






//func getAnimeUrlsFromAllPages () -> [String] {
//    tolokaLogin()
//    guard let url = URL(string: "https://toloka.to/f127") else {
//        fatalError("Invalid URL")
//    }
//    do {
//        let html = try String(contentsOf: url)
//        let doc: Document = try SwiftSoup.parse(html)
//
//        let links: [String] = try doc.select("a.topictitle")
//            .map { element in
//                guard let href = try? element.attr("href") else {
//                    return ""
//                }
//                return "https://toloka.to/\(href)"
//            }
//
//      print(links)
//    } catch {
//        print("Error: \(error)")
//    }
//    return []
//}






//func getAnimeInfo() {
//    let allLinksAnime = getAllUrlsToAnimeTopicsFromAllPages()
//    for link in allLinksAnime {
//        guard  let url = URL(string: link) else {return }
//        do {
//            let html = try String(contentsOf: url)
//
//            let doc: Document = try SwiftSoup.parse(html)
//
//
//
//            let title = try doc.select("title").first()?.text() ?? ""
//            print("\(title)!!!!!!!!!!!!!!!!!!!!!!!!!")
//        } catch {
//            print("Error: \(error)")
//        }
//    }
//
//}





//func extractAnimeData() {
//    let allLinksAnime = getAllUrlsToAnimeTopicsFromAllPages()
//    for link in allLinksAnime {
//        guard  let url = URL(string: link) else {return }
//        do {
//            let html = try String(contentsOf: url)
//            let doc: Document = try SwiftSoup.parse(html)
//            var anime = Anime(
//                            nameJap: nil,
//                            nameEng: nil,
//                            nameUkr: nil,
//                            studios: [],
//                            year: nil,
//                            genres: [],
//                            descr: nil,
//                            urlsDetails: []
//                        )
//            let title = try doc.select("title").first()?.text() ?? ""
//            anime.nameUkr = title
////            let studio = try doc.select("<tr><td colspan=\"2\" style=\"padding: 6px; border-top: 1px solid #ADBAC6;">").first()
////                .compactMap { try? $0.attr("Кінокомпанія:") }
//////            }
//        } catch {
//            print("Error: \(error)")
//        }
//    }
//}
       
