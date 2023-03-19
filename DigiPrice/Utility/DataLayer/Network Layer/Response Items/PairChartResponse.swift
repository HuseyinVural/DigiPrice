//
//  PairChartResponse.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

struct PairChartResponse: Decodable {
    let time: [Double]
    let close: [Double]
    
    private enum CodingKeys : String, CodingKey {
        case time = "t", close = "c"
    }
}
