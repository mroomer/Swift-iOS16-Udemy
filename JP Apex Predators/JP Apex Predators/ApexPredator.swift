//
//  ApexPredator.swift
//  JP Apex Predators
//
//  Created by Marnix Roomer on 03/01/2023.
//

import SwiftUI

struct ApexPredator: Codable, Identifiable { // Codable for JSON, Identifiable for ForEach
    let id: Int
    let name: String
    let type: String
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String
    
    func typeOverlay() -> Color {
        switch type {
        case "land":
            return .brown
        case "air":
            return .teal
        case "sea":
            return .blue
        default:
            return .brown
        }
    }
}

struct MovieScene: Codable, Identifiable { // Codable for JSON, Identifiable for ForEach
    let id: Int
    let movie: String
    let sceneDescription: String
}
