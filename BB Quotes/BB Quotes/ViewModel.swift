//
//  ViewModel.swift
//  BB Quotes
//
//  Created by Marnix Roomer on 04/01/2023.
//

import Foundation

@MainActor // Tells compiler to make sure that anything inside of this file that's going to affect the UI in a way, like the 'status' property, to make sure those things always run on the main thread.
class ViewModel: ObservableObject { // We are making our viewmodel observable so that our view can observe the viewmodel and keep track of any published properties we create.
    enum Status {
        case notStarted
        case fetching
        // Intermediate enums part, meaning we can attach data to these cases
        case success(data: (Quote, Character)) // We want to attach the retrieved data
        case failed(error: Error) // We want to see the error that made it fail
    }
    
    @Published private(set) var status: Status = .notStarted // 'private(set)' means that other files can see the property, but not change it.
    
    private let controller: FetchController // An instance of FetchController will be created in the actual view
    
    init(controller: FetchController) {
        self.controller = controller // Set the controller in this ViewModel to the controller from the view
    }
    
    func getData(from show: String) async {
        status = .fetching
        
        do {
            var quote = try await controller.fetchQuote() // Every time we call a function with 'throw' we have to say 'try'. And every time we call 'async' we have to say 'await'.
            
            while quote.series != show { // If the quote is not from the right show
                quote = try await controller.fetchQuote() // Get another quote
            }
            
            var characterName = quote.author
            
            if quote.author == "Gus Fring" {
                characterName = "Gustavo Fring"
            } else if quote.author == "Hank Schrader" {
                characterName = "Henry Schrader"
            } else if quote.author == "Jimmy McGill" {
                characterName = "Saul Goodman"
            } else if quote.author == "Kim Wexler" {
                characterName = "Kimberly Wexler"
            } else if quote.author == "Chuck McGill" {
                characterName = "Charles McGill"
            }
            
            let character = try await controller.fetchCharacter(name: characterName) // Fetch character data
            
            status = .success(data: (quote, character)) // Everything worked nice without errors
            // All status updates should run on the main thread, because they need to update the UI, this is why we add '@MainActor' to the top of the class
        } catch {
            status = .failed(error: error)
        }
    }
}
