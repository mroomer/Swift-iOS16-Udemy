//
//  TempPokemon.swift
//  Dex3
//
//  Created by Marnix Roomer on 08/01/2023.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    // Change to 'var', because compiler can't see if we only set it once in the switch statement
    // Initialize at 0, because compiler can't know if we actually initialize all the values in the switch statement
    // Now we don't have to tell the type 'Int' anymore, because we initialize at 0
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed = 0
    let sprite: URL
    let shiny: URL
    
    // When returning a string it automatically converts the case to a string.
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    // Because we are using enums and cases to identify the data that we're fetching, we need an init function
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)

        self.id = try container.decode(Int.self, forKey: .name)
        self.name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        self.types = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            // Maybe possible? Check after
//            let statValue = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                self.hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                self.attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                self.defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                self.specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                self.specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                self.speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("No more values")
            }
        }
        
        let spritesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        self.sprite = try spritesContainer.decode(URL.self, forKey: .sprite) // Apple will convert the String from the json to an URL
        self.shiny = try spritesContainer.decode(URL.self, forKey: .shiny) // Apple will convert the String from the json to an URL
    }
}
