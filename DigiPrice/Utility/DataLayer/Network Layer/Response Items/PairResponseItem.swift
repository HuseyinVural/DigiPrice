//
//  PairResponseItem.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

struct PairResponseItem: Decodable {
    let pair: String
    let pairNormalized: String
    let last: Double
    let volume: Double
    let dailyPercent: Double
    let denominatorSymbol: String
    let numeratorSymbol: String
}
