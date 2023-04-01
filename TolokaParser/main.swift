//
//  main.swift
//  TolokaParser
//
//  Created by Andrew Kuzmich on 24.03.2023.
//

import Foundation
import SwiftUI

makeRequest2()
//makeRequest4()
//LoginAction()

readLine()


func makeRequest2() {
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
        
        let resp = String(data: data, encoding: .utf8)
        print(resp!)
    }
    
    task.resume()
}

func getCookies() -> [HTTPCookie] {
    return [
        HTTPCookie(properties: [
            .name: "toloka_data",
            .value: "a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%22c3219d6f48aff8078a874ab8d7b95c44%22%3Bs%3A6%3A%22userid%22%3Bi%3A69985%3B%7D",
            .domain: "toloka.to",
            .path: "/",
            .expires: Date(timeIntervalSinceNow: 10),
            .comment: ""
        ])!,
        
        HTTPCookie(properties: [
            .name: "toloka_sid",
            .value: "af4ed5520cf7f5ae7cc62611edafc0df",
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
