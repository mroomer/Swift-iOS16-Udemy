//
//  Quote.swift
//  BB Quotes
//
//  Created by Marnix Roomer on 04/01/2023.
//

struct Quote: Codable {
    let quote: String
    let author: String
    let series: String
    
    // We can create an enum to decode only the wanted keys in a JSON file
    enum quoteKeys: String, CodingKey {
        case quote
        case author
        case series
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let quoteContainer = try container.nestedContainer(keyedBy: quoteKeys.self)
        
        self.quote = try quoteContainer.decode(String.self, forKey: .quote)
        self.author = try quoteContainer.decode(String.self, forKey: .author)
        self.series = try quoteContainer.decode(String.self, forKey: .series)
    }
}
