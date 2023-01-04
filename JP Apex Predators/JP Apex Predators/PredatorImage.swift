//
//  PredatorImage.swift
//  JP Apex Predators
//
//  Created by Marnix Roomer on 03/01/2023.
//

import SwiftUI

struct PredatorImage: View {
    @Environment(\.dismiss) var dismiss
    let predator: ApexPredator
    
    var body: some View {
        ZStack {
            Image(predator.type)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
                .padding(.bottom, 80)
            
            Image(predator.name.lowercased().filter { $0 != " " }) // lowercasing name and removing spaces to match up with image name
                .resizable()                                       // go through chars and if not a space keep, if a space remove
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .shadow(color: .black,radius: 6)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .padding(.leading, 20)
        }
        .edgesIgnoringSafeArea(.top) // tell scrollview to ignore safe areas so image goes to the top
        .toolbar {  // Add custom 'back' button for better visibility
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .padding(-4)
                    }
                    .foregroundColor(.white)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black.opacity(0.5))
                    }
                }
            }
        }
    }
}

struct PredatorImage_Previews: PreviewProvider {
    static var previews: some View {
        let movieScene = MovieScene(id: 3, movie: "Jurassic Park III", sceneDescription: "A young adult Tyrannosaurus appears in Jurassic Park 3. According to the official size charts, it is 37 feet long and 14.5 feet tall. When Alan Grant and the other survivors escape the Spinosaurus, they encounter the creature who is just feeding on another dinosaur. The group runs back towards the Spinosaurus and a huge battle occurs between the Tyrannosaurus and the Spinosaurus. The Spinosaurus kills the T-Rex by snapping its neck in its powerful jaws.")
        
        let movies = ["Jurassic Park", "The Lost World: Jurassic Park", "Jurassic Park III", "Jurassic World","Jurassic World: FallenKingdom"]
        
        let predator = ApexPredator(id: 3, name: "Tyrannosaurus Rex", type: "land", movies: movies, movieScenes: [movieScene], link: "https://jurassicpark.fandom.com/wiki/Tyrannosaurus_rex")
        
        PredatorImage(predator: predator)
    }
}
