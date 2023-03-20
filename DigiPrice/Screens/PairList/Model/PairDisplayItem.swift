//
//  PairItem.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

/// Model for holding basic data about a currency pair for display in the UI.
final class PairDisplayItem {
    /// The symbol representing the currency pair. It using item identification like id
    let symbol: String
    /// The name of the currency pair in the format of "numeratorSymbol**/**denominatorSymbol".
    let name: String
    /// The last traded price of the currency pair formatted as a string.
    let lastPrice: String
    /// The trading volume of the currency pair formatted as a string.
    let volume: String
    /// The percentage change in price over the last 24 hours formatted as a string.
    let dailyPercent: String
    /// The symbol representing the denominator currency.
    let denominatorSymbol: String
    /// The symbol representing the numerator currency.
    let numeratorSymbol: String
    /// Whether the currency pair is currently rising in price.
    let isRising: Bool
    /// Whether the currency pair is currently favorited by the user.
    var isFavorited: Bool
    /// Whether this instance represents a placeholder for display in the UI.
    let isPlaceholder: Bool
    
    /// The name of the color to use for displaying the daily percent value.
    var dailyPercentColorName: String {
        return isRising ? AppColors.highlightedPositiveColor.rawValue : AppColors.highlightedNegativeColor.rawValue
    }
    /// The name of the color to use for displaying the favorite icon.
    var favoriteIconColorName: String {
        return isFavorited ? AppColors.favoritedColor.rawValue : AppColors.unfavoriteColor.rawValue
    }
    
    /// Initializes a new PairDisplayItem with the given data and favorited status.
    ///
    /// - Parameters:
    ///   - data: The data to use for initializing the PairDisplayItem.
    ///   - isFavorited: Whether the currency pair is currently favorited by the user.
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
    
    /// Initializes a new PairDisplayItem instance representing a placeholder for display in the UI.
    ///
    /// - Parameters:
    ///   - isRising: Whether the placeholder should indicate a rising or falling price.
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
