//
//  DataRepositoryProtocol.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func getFavorites() async throws -> Set<String>
    func setFavorite(_ pair: String)
    func removeFavorite(_ pair: String)
}

/**
 A separate protocol has been created to emphasize interface segregation and to prevent the chart display from accessing services that are not needed.
 */
protocol ChartRepositoryProtocol {
    func getChartDetail(symbol: String, resolution: Int, from: Int, to: Int) async throws -> PairChartResponse
}

protocol PairsRepositoryProtocol {
    func getPairs(symbol: String?) async throws -> [PairResponseItem]
}

protocol DataRepositoryProtocol: FavoritesRepositoryProtocol, ChartRepositoryProtocol, PairsRepositoryProtocol {}
