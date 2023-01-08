//
//  FetchController.swift
//  BB Quotes
//
//  Created by Marnix Roomer on 04/01/2023.
//

import Foundation

struct FetchController {
    
    // When working with API's or URL's there might be a lot of errors not related to your code. Like now the Breaking Bad API is down
    enum NetworkError: Error {
        case badURL, badResponse
    }
    
    private let baseURL = URL(string: "https://www.breakingbadapi.com/api/")!
    
    func fetchQuote() async throws -> Quote { // 'async' for multithreading; Apple wants UI stuff on the main thread so the screen never freezes. 'async' can be used for slower/longer taking processes to not block more important functions.
        let quoteURL = baseURL.appendingPathComponent("quote/random")
        
        // URL session, when going to a URL online; You will get the data and a response with status code. (Like 'error 404')
        let (data, response) = try await URLSession.shared.data(from: quoteURL) // 'await' must be used when calling 'async' functions. And this funcion we call is also 'async', which is why we use it
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // 200 is a good response code, meaning everything okay!
            throw NetworkError.badResponse
        }
        
        let quote = try JSONDecoder().decode(Quote.self, from: data) // Try and decode the retrieved 'data'
        
        return quote
    }
    
    func fetchCharacter(name: String) async throws -> Character {
        let characterURL = baseURL.appendingPathComponent("characters")
        // A URL is made up of different URL Components. After the questionmark in the URL is a 'query item'
        var characterComponents = URLComponents(url: characterURL, resolvingAgainstBaseURL: true)
        let characterQueryItem = URLQueryItem(name: "name", value: name) // Name of the query item in the URL is 'name' and the value will be the character name
        characterComponents?.queryItems = [characterQueryItem] // We put a questionmark, because URL's can be quite iffy
        
        guard let searchURL = characterComponents?.url else { // Check if we messed up the URL
            throw NetworkError.badURL
        }
        
        // URL session, when going to a URL online; You will get the data and a response with status code. (Like 'error 404')
        let (data, response) = try await URLSession.shared.data(from: searchURL) // 'await' must be used when calling 'async' functions. And this funcion we call is also 'async', which is why we use it
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // 200 is a good response code, meaning everything okay!
            throw NetworkError.badResponse
        }
        
        let character = try JSONDecoder().decode(Character.self, from: data) // Try and decode the retrieved 'data'
        
        return character
    }
}
