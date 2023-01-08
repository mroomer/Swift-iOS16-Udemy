//
//  CharacterView.swift
//  BB Quotes
//
//  Created by Marnix Roomer on 07/01/2023.
//

import SwiftUI

struct CharacterView: View {
    let show: String
    let character: Character
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack { // VStack to prevent the background image from moving down with the character image
                    Image(show.lowercased().filter { $0 != " " })
                        .resizable()
                    .scaledToFit()
                    
                    Spacer() // Spacer to push the background image to the top of the VStack/screen
                }
                
                VStack {
//                    Image("jessepinkman")
//                        .resizable()
//                        .scaledToFit()
//                        .cornerRadius(25)
//                        .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 2)
//                        .padding(.top, 50)
                    AsyncImage(url: character.image) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(25)
                            .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 2)
                            .padding(.top, 50)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(alignment: .leading) {
//                        Text("Jesse Pinkman")
                        Text(character.name)
                            .font(.largeTitle)
                        
//                        Text("Portrayed By: Aaron Paul")
                        Text("Portrayed By: \(character.portrayedBy)")
                            .font(.subheadline)
                        
//                        Text("Jesse Pinkman Character Info")
                        Text("\(character.name) Character Info")
                            .font(.title2)
                            .padding(.top, 7)
                        
//                        Text("Born: 09-24-1984")
                        Text("Born: \(character.birthday)")
                        
//                        Text("Occupations: Meth Dealer")
                        Text("Occupations: \(character.occupation.joined(separator: ", "))") // '.joined' can be used to join an array of strings together.
                        
//                        Text("Nickname: Cap'n Cook")
                        Text("Nickname: \(character.nickname)")
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        // We can use the 'samplecharacter' file to initialize a decoded character for the view
        CharacterView(show: "Breaking Bad", character: try! JSONDecoder().decode(Character.self, from: Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!))) // Is a simplified version of the json decoder used in the JP Apex Predators app
    }
}
