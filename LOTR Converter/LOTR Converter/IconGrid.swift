//
//  IconGrid.swift
//  LOTR Converter
//
//  Created by Marnix Roomer on 02/01/2023.
//

import SwiftUI

struct IconGrid: View {
    @State var gridLayout = [GridItem(), GridItem(), GridItem()]
    @Binding var currency: Currency
    
    var body: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(0..<5) { i in
                if Currency.allCases[i] == currency { // Selected Currency
                    CurrencyIcon(currencyImage: CurrencyImage.allCases[i].rawValue, currencyText:  CurrencyText.allCases[i].rawValue) // need .allCases to access array subscript
                        .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 3)
                            .opacity(0.5))
                        .shadow(color: .black, radius: 9)
                } else { // not selected, no border or shadow
                    CurrencyIcon(currencyImage: CurrencyImage.allCases[i].rawValue, currencyText: CurrencyText.allCases[i].rawValue)
                        .onTapGesture { // only unselected icons are tappable, bound currency is set to tapped currency
                            currency = Currency.allCases[i]
                        }
                }
            }
        }
        .padding([.bottom, .leading, .trailing])
    }
}

struct IconGrid_Previews: PreviewProvider {
    static var previews: some View {
        IconGrid(currency: .constant(.silverPiece)) // .contant needed for Bound values
    }
}
