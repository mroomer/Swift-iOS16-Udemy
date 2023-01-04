//
//  SelectCurrency.swift
//  LOTR Converter
//
//  Created by Marnix Roomer on 02/01/2023.
//

import SwiftUI

struct SelectCurrency: View {
    @Environment(\.dismiss) var dismiss
    @Binding var leftCurrency: Currency
    @Binding var rightCurrency: Currency

    var body: some View {
        ZStack {
            // Background parchment image
            Image("parchment")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .background(.brown)
            
            VStack {
                // Text
                Text("Select the currency you are starting with:")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing])
                
                // Currency icons
                IconGrid(currency: $leftCurrency) // $ - binds to currency in IconGrid
                
                // Text
                Text("Select the currency you would like to convert to:")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing])
                
                // Currency icons
                IconGrid(currency: $rightCurrency)
                
                // Done button
                Button("Done") {
                    dismiss()
                }
                .font(.largeTitle)
                .padding(10)
                .foregroundColor(.white) // this takes precident over the foregroundColor below, because it was specifically set on the view
                .background(.brown)
                .cornerRadius(15)
            }
            .foregroundColor(.black) // so text stays black in dark-mode, else ith will turn white on the toggle
        }
    }
}

struct SelectCurrency_Previews: PreviewProvider {
    static var previews: some View {
        SelectCurrency(leftCurrency: .constant(.silverPiece), rightCurrency: .constant(.goldPiece)) // .contant needed for Bound values
//            .preferredColorScheme(.dark) // Switch to dark mode
    }
}
