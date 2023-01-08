//
//  QuoteView.swift
//  BB Quotes
//
//  Created by Marnix Roomer on 07/01/2023.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    let show: String
    @State var showCharacterScreen = false
    
    var body: some View {
        ZStack {
//            Image("breakingbad")
            Image(show.lowercased().filter { $0 != " " })
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 2.7, height: UIScreen.main.bounds.height * 1.1)
            
            VStack { // To anchor the button on the bottom and stop it from moving up and down when switching 'views'
                VStack {
                    Spacer()
                    Spacer()
                    
                    switch viewModel.status {
                    case .success(let data):
                        //                    Text("\"You either run from things, or you face them, Mr. White\"")
                        Text("\"\(data.0.quote)\"")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                        
                        ZStack {
                            //                        Image("jessepinkman")
                            //                            .resizable()
                            //                            .scaledToFill()
                            AsyncImage(url: data.1.image) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 1.8)
                            } placeholder: { // What to show when the image is being retrieved
                                ProgressView()
                            }
                            .onTapGesture { // Functional modifiers need to go at the end of an image/view. Design modifiers can go as seen above
                                showCharacterScreen.toggle()
                            }
                            .sheet(isPresented: $showCharacterScreen) {
                                CharacterView(show: show, character: data.1)
                            }
                            
                            VStack {
                                Spacer()
                                
                                Text(data.0.author)
                                //                            Text("Jesse Pinkman")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity) // Infinity means go to the edges of the parent view, in this case means to the edges of the ZStack/Image
                                    .background(.gray.opacity(0.33))
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 1.8)
                        .cornerRadius(80)
                        
                    case .fetching:
                        ProgressView()
                            .padding([.top, .bottom], 270)
                        
                    case .failed:
                        Text("Data Failed")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(10)
                            .padding(.horizontal, 10)
                            .background(Color(.black))
                            .cornerRadius(50)
                        
                    default: // Cover all other cases
                        EmptyView()
                    }
                    
                    Spacer()
                }
                
                Button("Get Random Quote") {
                    Task { // Used to call a asynchronous function in a non-asynchronous place. Like a view (Which always runs on the main thread)
                        await viewModel.getData(from: show)
                    }
                }
                .font(.title)
                .foregroundColor(.white)
                .padding()
//                .background(Color("BreakingBadGreen"))
                .background(Color(show.filter { $0 != " " } + "Button"))
                .cornerRadius(7)
                .shadow(color: Color(show.filter { $0 != " " } + "Shadow"), radius: 2)
                .padding(.bottom, 100)
                
                Spacer()
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(show: "Breaking Bad")
    }
}
