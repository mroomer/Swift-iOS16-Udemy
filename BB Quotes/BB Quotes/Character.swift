//
//  Character.swift
//  BB Quotes
//
//  Created by Marnix Roomer on 04/01/2023.
//

import Foundation

struct Character: Codable {
    let name: String
    let birthday: String
    let occupation: [String]
    let image: URL
    let nickname: String
    let portrayedBy: String
    
    // We can create an enum to decode only the wanted keys in a JSON file
    enum characterKeys: String, CodingKey {
        case name
        case birthday
        case occupation
        case image = "img" // This way we can tweak the names for our code, but we must give the JSON 'key' exactly
        case nickname
        case portrayedBy = "portrayed" // This way we can tweak the names for our code, but we must give the JSON 'key' exactly
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let characterContainer = try container.nestedContainer(keyedBy: characterKeys.self)
        
        self.name = try characterContainer.decode(String.self, forKey: .name)
        self.birthday = try characterContainer.decode(String.self, forKey: .birthday)
        self.occupation = try characterContainer.decode([String].self, forKey: .occupation)
        self.image = try characterContainer.decode(URL.self, forKey: .image)
        self.nickname = try characterContainer.decode(String.self, forKey: .nickname)
        self.portrayedBy = try characterContainer.decode(String.self, forKey: .portrayedBy)
    }
}
