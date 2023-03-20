//
//  Double+Extensions.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

extension Double {
    /// Formats Float price using "Decimal" number formatter without Currency symbol
    ///
    /// - Parameters:
    ///   - priceLocale: Locale to format product with.
    ///   - maxFractionDigits: Default **6** after comma
    /// - Returns: Formatted string with given parameters.
    public func localizedPrice(_ priceLocale: Locale = .current, maxFractionDigits: Int = 6) -> String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = .none
        formatter.locale = priceLocale
        formatter.maximumFractionDigits = maxFractionDigits
        return formatter.string(from: value) ?? "-"
    }
    
    /// Formats a `Double` value as a percentage string with optional locale.
    /// - Parameters:
    ///   - locale: An optional `Locale` object to use for formatting.
    /// - Returns: A percentage string formatted from the `Double` value.
    func percentFormatted(locale: Locale = .current) -> String? {
        let number = (self / 100) as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.locale = locale
        numberFormatter.maximumFractionDigits = 3
        return numberFormatter.string(from: number)
    }
}
