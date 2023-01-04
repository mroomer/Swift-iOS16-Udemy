//
//  ContentView.swift
//  JP Apex Predators
//
//  Created by Marnix Roomer on 03/01/2023.
//

import SwiftUI

struct ContentView: View {
    let apController = PredatorController() // create instance of a Predator Controller and runs init to decode JSON data
    @State var sortAlphabetical = false
    @State var currentFilter = "All"
    @State var currentMovieFilter = "All"
    @State private var searchText = ""
    
    // Every @State var change will cause the entire screen to refresh and all the code to run again
    var body: some View {
        apController.filterBy(type: currentFilter) // Filter by type first
        apController.filterByMovie(movie: currentMovieFilter) // Filter type by movie after
        apController.filterBySearchText(searchText: searchText) // Filter by search text after to overwrite the other filters
        
        // Need to add return to NavigationView, or the below if statement thinks the one liners are trying to implicitly return a View
        if sortAlphabetical {
            apController.sortByAlphabetical()
        } else {
            apController.sortByMovieAppearance()
        }
        
        // returns single view
        return NavigationView {
            List {
                if apController.apexPredators.isEmpty {
                    Text("No Predators found")
                } else {
                    ForEach(apController.apexPredators) { predator in
                        NavigationLink(destination: PredatorDetail(predator: predator).navigationBarBackButtonHidden()) {
                            PredatorRow(predator: predator)
                        }
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText, prompt: "Search for a Predator")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation { // creates a shuffle effect
                            sortAlphabetical.toggle() // toggles state change, View refreshed and re-sorted
                        }
                    } label: {
                        if sortAlphabetical {
                            Image(systemName: "film")
                        } else {
                            Image(systemName: "textformat")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentFilter.animation()) { // $currentFilter bound to Picker, will update State and cause re-render also adds animation picker menu bounces out
                            ForEach(apController.typeFilters, id: \.self) { type in // make string array identifiable
                                HStack {
                                    Text(type)
                                    
                                    Spacer()
                                    
                                    Image(systemName: apController.typeIcon(for: type)) // icon names in switch statement in controller
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("MovieFilter", selection: $currentMovieFilter.animation()) { // $currentFilter bound to Picker, will update State and cause re-render also adds animation picker menu bounces out
                            ForEach(apController.movieFilters, id:\.self) { type in // make string array identifiable
                                HStack {
                                    Text(type)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "video")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
