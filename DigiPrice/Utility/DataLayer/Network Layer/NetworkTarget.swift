//
//  NetworkTarget.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

/// A type that represents an endpoint for the BTC Turk API.
public enum NetworkTarget {
    
    /// A target for fetching pair symbols.
    ///
    /// - Parameters:
    ///   - pairSymbol: An optional symbol for a specific pair. Defaults to nil, which returns all available pairs.
    case pairs(pairSymbol: String?)
    
    /// A target for fetching chart data for a specific pair.
    ///
    /// - Parameters:
    ///   - symbol: The symbol for the pair, e.g. "BTCTRY".
    ///   - resolution: The resolution of the data, in minutes.
    ///   - from: The start time of the data, in UNIX timestamp format.
    ///   - to: The end time of the data, in UNIX timestamp format.
    case pairChartData(symbol: String, resolution: Int, from: Int, to: Int)
    
    /// The base URL for the endpoint.
    var baseURL: String {
        switch self {
        case .pairs:
            return "https://api.btcturk.com/api"
        case .pairChartData:
            return "https://graph-api.btcturk.com"
        }
    }
    
    /// The path component of the endpoint's URL.
    var path: String {
        switch self {
        case .pairs:
            return "/v2/ticker"
        case .pairChartData:
            return "/v1/klines/history"
        }
    }
    
    /// The query string for the endpoint's URL.
    var query: String {
        switch self {
        case .pairs(let pairSymbol):
            return "?pairSymbol=\(pairSymbol ?? "")"
        case .pairChartData(let symbol, let resolution, let from, let to):
            return "?symbol=\(symbol)&resolution=\(resolution)&from=\(from)&to=\(to)"
        }
    }
}
