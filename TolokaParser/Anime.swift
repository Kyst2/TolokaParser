import Foundation

struct Anime {
   var nameJap: String?
   var nameEng: String?
   var nameUkr: String?
   var studios: [String]
   var year: Int?
   var genres: [String]?
   var descr: String?
   var urlsDetails: [UrlsDetails]
}

struct UrlsDetails {
   var fanDubStudio: String
   var urls: [URL]
}


