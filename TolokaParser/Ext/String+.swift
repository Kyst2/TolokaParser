import Foundation

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
    
    func replace(of: String, to: String) -> String {
        return self.replacingOccurrences(of: of, with: to, options: .regularExpression, range: nil)
    }
}
