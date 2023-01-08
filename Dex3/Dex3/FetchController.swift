//
//  FetchController.swift
//  Dex3
//
//  Created by Marnix Roomer on 08/01/2023.
//

import Foundation

struct FetchController {
    
    // When working with API's or URL's there might be a lot of errors not related to your code. Like now the Breaking Bad API is down
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func fetchAllPokemon() async throws -> [TempPokemon] { // 'async' for multithreading; Apple wants UI stuff on the main thread so the screen never freezes. 'async' can be used for slower/longer taking processes to not block more important functions.
        var allPokemon: [TempPokemon] = []
        
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")] // https://pokeapi.co/api/v2/pokemon + ?limit=386
        
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        // 'String: Any' means any type
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], // Gets all data
                let pokeDex = pokeDictionary["results"] as? [[String: String]] // Check 'results' data
        else {
            throw NetworkError.badData
        }
        
        for pokemon in pokeDex {
            if let url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        
        return allPokemon
    }
    
    // Get data for a single pokemon from URL
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check response code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        print("Fetched \(tempPokemon.id): \(tempPokemon.name)") // Print "id: name" in log
        
        return tempPokemon
    }
}
