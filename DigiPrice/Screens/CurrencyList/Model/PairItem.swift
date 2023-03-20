//
//  PairItem.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

final class PairDisplayItem {
    let symbol: String
    let name: String
    let lastPrice: String
    let volume: String
    let dailyPercent: String
    let denominatorSymbol: String
    let numeratorSymbol: String
    let isRising: Bool
    var isFavorited: Bool
    let isPlaceholder: Bool
    
    var dailyPercentColorName: String {
        return isRising ? AppColors.highlightedPositiveColor.rawValue : AppColors.highlightedNegativeColor.rawValue
    }
    var favoriteIconColorName: String {
        return isFavorited ? AppColors.favoritedColor.rawValue : AppColors.unfavoriteColor.rawValue
    }
    
    init(data: PairResponseItem, isFavorited: Bool) {
        self.symbol = data.pair
        self.numeratorSymbol = data.numeratorSymbol
        self.name = data.numeratorSymbol + "/" + data.denominatorSymbol
        self.lastPrice = data.last.localizedPrice()
        self.volume = data.volume.localizedPrice(maxFractionDigits: 3) + " " + numeratorSymbol
        self.dailyPercent = data.dailyPercent.percentFormatted() ?? "-"
        self.denominatorSymbol = data.denominatorSymbol
        self.isFavorited = isFavorited
        self.isRising = data.dailyPercent > 0
        self.isPlaceholder = false
    }
    
    init(isRising: Bool) {
        self.numeratorSymbol = "NumeratorName"
        self.name = "PairName"
        self.lastPrice = "Last"
        self.volume = "Volume + NumeratorName"
        self.dailyPercent = "DailyPercent"
        self.denominatorSymbol = "DenominatorSymbol"
        self.isFavorited = false
        self.isRising = isRising
        self.isPlaceholder = true
        self.symbol = self.name
    }
}
