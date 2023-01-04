//
//  PredatorController.swift
//  JP Apex Predators
//
//  Created by Marnix Roomer on 03/01/2023.
//

import Foundation

class PredatorController {
    private var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []
    let typeFilters = ["All", "Land", "Air", "Sea"]
    let movieFilters = ["All", "Jurassic Park", "The Lost World: Jurassic Park", "Jurassic Park III", "Jurassic World", "Jurassic World: Fallen Kingdom"]
    
    init() { // Runs when creating a new instance of PredatorController
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // allows decoding from json snake_case to camel case
                allApexPredators = try decoder.decode([ApexPredator].self, from: data) // use the all array
                apexPredators = allApexPredators // apexPredators will be used for filtering below
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
    
    func typeIcon(for type: String) -> String {
        switch type {
        case "All":
            return "square.stack.3d.up.fill"
        case "Land":
            return "leaf.fill"
        case "Air":
            return "wind"
        case "Sea":
            return "drop.fill"
        default:
            return "questionmark"
        }
    }
    
    func filterBy(type: String) {
        switch type {
        case "Land", "Air", "Sea":
            apexPredators = allApexPredators.filter { // filter: true == keep, false == remove, not implace creates a temp array and assigns it to the apexPredators array
                $0.type == type.lowercased()
            }
        default:
            apexPredators = allApexPredators // "All" would be included in default clause
        }
    }
    
    func filterByMovie(movie: String) {
        switch movie {
        case "Jurassic Park", "The Lost World: Jurassic Park", "Jurassic Park III", "Jurassic World", "Jurassic World: Fallen Kingdom":
            apexPredators = apexPredators.filter { // filter: true == keep, false == remove, not implace creates a temp array and assigns it to the apexPredators array
                $0.movies.contains(movie)
            }
        default:
            return
        }
    }
    
    
    func filterBySearchText(searchText: String) {
        if searchText.isEmpty {
            return
        } else {
            apexPredators = allApexPredators.filter { // filter: true == keep, false == remove, not implace creates a temp array and assigns it to the apexPredators array
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func sortByAlphabetical() {
        apexPredators.sort(by: {  // sort: inplace - sorts the given array order
            $0.name < $1.name
        })
    }
    
    func sortByMovieAppearance() {
        apexPredators.sort(by: { // sort: inplace - sorts the given array order
            $0.id < $1.id
        })
    }
}
