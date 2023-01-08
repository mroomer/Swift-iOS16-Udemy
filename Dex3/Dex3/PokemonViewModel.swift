//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Marnix Roomer on 08/01/2023.
//

import Foundation

@MainActor // Tells compiler to make sure that anything inside of this file that's going to affect the UI in a way, like the 'status' property, to make sure those things always run on the main thread.
class PokemonViewModel: ObservableObject { // We are making our viewmodel observable so that our view can observe the viewmodel and keep track of any published properties we create.
    enum Status {
        case notStarted
        case fetching
        // Intermediate enums part, meaning we can attach data to these cases
        case success // Don't attach data this time, because data is going to be stored in the core database this time
        case failed(error: Error) // We want to see the error that made it fail
    }
    
    @Published private(set) var status: Status = .notStarted // 'private(set)' means that other files can see the property, but not change it.
    
    private let controller: FetchController // An instance of FetchController will be created in the actual view
    
    init(controller: FetchController) {
        self.controller = controller // Set the controller in this ViewModel to the controller from the view
        
        Task { // Can't run async function in init code, except if it's in a Task
            await getPokemon() // Initialize whenever the PokemonViewModel gets initialized so the user doesn't have to click or wait
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        
        do {
            var pokedex = try await controller.fetchAllPokemon()
            
            pokedex.sort { $0.id < $1.id } // We need to sort the pokemon so that the pokemon are in the right order, but we can also guarantee it.
            
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id) // Convert 'Int' to 'Int16' to save core data
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                
                try PersistenceController.shared.container.viewContext.save() // Save to core data
            }
            
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
