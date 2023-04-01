//
//  main.swift
//  TolokaParser
//
//  Created by Andrew Kuzmich on 24.03.2023.
//

import Foundation
import SwiftUI
import Alamofire
//import UIKit

//makeRequest2()
//makeRequest4()
//LoginAction()
makeRequest8()
readLine()

struct Cours: Hashable, Codable {
    let date: String
    let bank: String
    let baseCurrency: Int
    let baseCurrencyLit: String
    let exchangeRate:[String]
}

func makeRequest9() {
    guard let url = URL(string: "https://toloka.to/login.php") else {return}
    let parameters = ["username": "kystozavr","password":"19761972"]
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters,options: []) else {return}
    request.httpBody = httpBody
    let session = URLSession.shared
    session.dataTask(with: url) { data, response, error in
        if let response = response {
            print(response)
        }
        guard let data = data else {return}
        do {
            let json = try JSONSerialization.jsonObject(with: data,options: [])
            print(json)
        }catch {
            print(error)
        }
    }.resume()
}



// Define a struct to represent the ExchangeRates data
struct ExchangeRates: Codable {
    let exchangeRate: [ExchangeRate]
}

struct ExchangeRate: Codable {
    let baseCurrency: String
    let currency: String
    let saleRateNB: Double
    let purchaseRateNB: Double
    let saleRate: Double
    let purchaseRate: Double
}

func makeRequest8() {

    // Specify the API URL with the date parameter
    let urlString = "https://api.privatbank.ua/p24api/exchange_rates?json&date=01.12.2020"

    // Create a URL object from the string
    guard let url = URL(string: urlString) else {
        print("Error: Invalid URL")
        exit(1)
    }

    // Create an URLSession object to make the request
    let session = URLSession.shared

    // Create a data task to retrieve the data
    let task = session.dataTask(with: url) { data, response, error in
        // Check for errors
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        // Check the response status code
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("Error: Invalid response")
            return
        }
        
        // Check that the data is not nil
        guard let data = data else {
            print("Error: No data received")
            return
        }
        
        // Decode the JSON data
        let decoder = JSONDecoder()
        guard let exchangeRates = try? decoder.decode(ExchangeRates.self, from: data) else {
            print("Error: Failed to decode JSON data")
            return
        }
        
        // Print the exchange rate data
        print(exchangeRates.exchangeRate)
    }

    // Start the task
    task.resume()

 

}

func makeRequest7() {

    // Define the login URL and credentials
    let loginUrl = URL(string: "https://toloka.to/login.php")!
    let username = "kystozavr"
    let password = "197619"
    let ssl = false
    let autologin = false
    let loginData = "username=\(username)&password=\(password)&login=%C2%F5%EE%E4&autologin\(autologin)&ssl=\(ssl)".data(using: .utf8)!

    // Create the login request
    var request = URLRequest(url: loginUrl)
    request.httpMethod = "POST"
    request.httpBody = loginData
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    // Create the URLSession
    let session = URLSession.shared

    // Start the login task
    let task = session.dataTask(with: request) { data, response, error in
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                // Login successful
                print(httpResponse)
                print("Login successful")
            } else {
                // Login failed
                print("Login failed")
            }
        } else if let error = error {
            // Handle error
            print("Login error: \(error.localizedDescription)")
        }
    }
    task.resume()

}


// First, log in to the website as shown in the previous example
// ...

// Get the cookies from the response

func makeRequest6() {
    
    // Set up the login request
    let loginUrl = URL(string: "https://toloka.to/login.php?redirect=index.php&")!
    var request = URLRequest(url: loginUrl)
    request.httpMethod = "POST"

    // Set the request body
    let username = "kystozavr"
    let password = "19761972"
    let authString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
    request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
    // Set other request headers if needed

    // Send the login request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let response = response as? HTTPURLResponse else {
            print("Invalid response received")
            return
        }
        guard let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.allHeaderFields as! [String : String], for: loginUrl) as? [HTTPCookie] else {
            print("No cookies received")
            return
        }
        // Store the cookies for future requests
        let cookieStorage = HTTPCookieStorage.shared
        for cookie in cookies {
            cookieStorage.setCookie(cookie)
        }

        // Send a request using the stored cookies
        let profileUrl = URL(string: "https://toloka.to/f127")!
        var profileRequest = URLRequest(url: profileUrl)
        let cookieHeader = HTTPCookie.requestHeaderFields(with: cookieStorage.cookies(for: profileUrl) ?? [])
        profileRequest.allHTTPHeaderFields = cookieHeader

        let profileTask = URLSession.shared.dataTask(with: profileRequest) { data, response, error in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            guard let profileData = data else {
                print("No profile data received")
                return
            }
            // Process the profile data here
            print(String(data: profileData, encoding: .utf8) ?? "Unable to convert profile data to string")
        }
        profileTask.resume()
    }
    task.resume()

}









let cookies11: [HTTPCookie] = [
    HTTPCookie(properties: [
        .name: "toloka_data",
        .value: "a%3A2%3A%7Bs%3A11%3A%22autologinid%22%3Bs%3A32%3A%224efbf450b71613b4e0eda9ffaa4488b5%22%3Bs%3A6%3A%22userid%22%3Bi%3A69985%3B%7D",
        .domain: "toloka.to",
        .path: "/",
        .expires: Date(timeIntervalSinceNow: 10),
        .comment: ""
    ])!,
    
    HTTPCookie(properties: [
        .name: "toloka_sid",
        .value: "fe2e2f26786680746ce58023a1a57a25",
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

extension URLRequest {
    mutating func setBasicAuth(username: String, password: String) {
        let encodedAuthInfo = String(format: "%@:%@", username, password)
            .data(using: String.Encoding.utf8)!
            .base64EncodedString()
        addValue("Basic \(encodedAuthInfo)", forHTTPHeaderField: "Authorization")
    }
}

func LoginAction() {
var username = "kystozavr"
    var password = "19761972"
        //POST request
        var request = URLRequest(url: URL(string: "https://toloka.to/login.php?redirect=index.php&")!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            print(String(data: data, encoding: .utf8) ?? "Unable to convert response data to string")
        }
    task.resume()
    }

func makeRequest4() {
    var request = URLRequest(url: URL(string: "https://toloka.to")!)
    request.setBasicAuth(username: "kystozavr", password: "19761972")
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data received")
            return
        }
        // Process the response data here
        print(String(data: data, encoding: .utf8) ?? "Unable to convert response data to string")
    }
    task.resume()
}

func makeRequest3(){
    let username = "kystozavr"
    let password = "19761972"

    // Create the authentication header
    let loginString = "\(username):\(password)"
    guard let loginData = loginString.data(using: String.Encoding.utf8) else {
        print("Unable to convert username and password to data")
        return
    }
    let base64LoginString = loginData.base64EncodedString()

    // Create the URL request and add the authentication header
    let url = URL(string: "https://toloka.to/f127")
    var request = URLRequest(url: url!)
    request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    // Make the request using URLSession
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data received")
            return
        }
        // Process the response data here
        print(String(data: data, encoding: .utf8) ?? "Unable to convert response data to string")
    }
    task.resume()
}
//print("3")

func makeRequest2() {
    guard let url = URL(string: "https://toloka.to/f127") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Make the request using URLSession
    let session = URLSession.shared
    
//    DispatchQueue.main.async {
//        for c in cookies11 {
//            session.configuration.httpCookieStorage?.setCookie(c)
//        }
//    }
    
    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data else { return }
        
        let resp = String(data: data, encoding: .utf8)
        print(resp!)
    }
    
    task.resume()
}


//func makeRequest() {
//    // Create a URL object from the URL string
//    guard let url = URL(string: "https://api.tomorrow.io/v4/timelines") else {
//        print("Invalid URL")
//        return
//    }
//
//    // Create URL components to add query parameters
//    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
//    urlComponents?.queryItems = [
//        URLQueryItem(name: "location", value: "40.75872069597532,-73.98529171943665"),
//        URLQueryItem(name: "fields", value: "temperature"),
//        URLQueryItem(name: "timesteps", value: "1h"),
//        URLQueryItem(name: "units", value: "metric"),
//        URLQueryItem(name: "apikey", value: "yDqgEw4LgL1D1PyMJLcYRWLRnS0DzfGA")
//    ]
//    // Create a URLRequest object with the URL and HTTP method
//    //https://www.youtube.com/watch?t=60&v=np8efvGqPNc&feature=youtu.be
//    guard let requestUrl = urlComponents?.url else {
//        print("Invalid URL")
//        return
//    }
//    
//    var request = URLRequest(url: requestUrl)
//    request.httpMethod = "GET"
//
//    // Make the request using URLSession
//    let session = URLSession.shared
//    
//    let task = session.dataTask(with: request) { data, response, error in
//        guard let data = data else { return }
//        
//        let resp = String(data: data, encoding: .utf8)
//        print(resp!)
//        
//        // Handle the response data or error
//        // Assuming you have the JSON data in a variable named jsonData
//        do {
//            let response = try JSONDecoder().decode(Response.self, from: data)
//            
//            
//            if let temperature = response.data.timelines.first?.intervals.first?.values.temperature {
//                print("Temperature: \(temperature)")
////                self.tempritcha = temperature
//            } else {
//                print("Unable to get temperature value")
//            }
//
//            // Access the decoded data using the response object
//        } catch {
//            // Handle the decoding error
//            print("Error decoding JSON: \(error)")
//        }
//        
//    }
//    task.resume()
//}
