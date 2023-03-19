//
//  DataRepository.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

/**
 The DataRepository class that conforms to DataRepositoryProtocol.
 Manages and abstracts communication with Memory, Network or persistent data providers.
 */
open class DataRepository: DataRepositoryProtocol {
    private let favoriteDataProvider: FavoriteDataProvidable
    private let networkProvider: NetworkProvidable
    
    /**
     Initializes the DataRepository with dependencies.
     You can use a new dependency model for your testing needs.
     Default dependencies prod environment provides a fast launcher.
     It also simplifies method injection for legacy projects.

     - Parameters:
        - dependencies: The dependencies of the DataRepository.
     */
    init(dependencies: Dependencies) {
        self.favoriteDataProvider = dependencies.favoriteDataProvider
        self.networkProvider = dependencies.networkProvider
    }
}

// MARK: - Pair List Operations
extension DataRepository: PairsRepositoryProtocol {
    /**
     Retrieves a list of PairResponseItems for a specific symbol or all.

     - Parameters:
        - symbol: The symbol for the PairResponseItems to retrieve.
        - If the symbol is nil, it returns the entire list.

     - Returns: An array of PairResponseItems.
     
     - Throws: An error of type DataOperationError, APIError or primitive error.
     */
    func getPairs(symbol: String?) async throws -> [PairResponseItem] {
        let response: BaseResponseItem<[PairResponseItem]> = try await networkProvider.request(.pairs(pairSymbol: symbol))
        
        if let pairs = response.data, response.success == true {
            return pairs
        } else {
            throw DataOperationError.missingData(message: response.message, code: response.code)
        }
    }
}

// MARK: - Chart Detail Operations
extension DataRepository: ChartRepositoryProtocol {
    /**
     Retrieves PairChartResponse for a specific symbol, resolution, from and to values.
     - Returns: A PairChartResponse.
     - Throws: An error of type DataOperationError, APIError or primitive error.
     */
    func getChartDetail(symbol: String, resolution: Int, from: Int, to: Int) async throws -> PairChartResponse {
        return try await networkProvider.request(.pairChartData(symbol: symbol, resolution: resolution, from: from, to: to))
    }
}

// MARK: - Favorite Operations
extension DataRepository: FavoritesRepositoryProtocol {
    /**
     Retrieves a set of favorite pairs.
     Allows MainContext to be updated. It does not take the responsibility of being recorded.
     It deduplicates the content it receives as an array.
     - Throws: An error of type Error.
     */
    func getFavorites() async throws -> Set<String> {
        return try await withCheckedThrowingContinuation({ continuation in
            favoriteDataProvider.getFavorites { result in
                switch result {
                case .success(let pairs):
                    let reduce = Set(pairs.map { $0 })
                    continuation.resume(with: .success(reduce))
                case .failure(let error):
                    continuation.resume(with: .failure(error))
                }
            }
        })
    }
    
    /**
     Allows MainContext to be updated. It does not take the responsibility of being recorded.
     - Parameters:
        - pair: The favorite pair to add. **"BTCTRY"
     */
    func setFavorite(_ pair: String) {
        favoriteDataProvider.setFavorite(pair)
    }
    
    /**
     Allows MainContext to be updated. It does not take the responsibility of being recorded.
     - Parameters:
        - pair: The favorite pair to add. **"BTCTRY"
     */
    func removeFavorite(_ pair: String) {
        favoriteDataProvider.removeFavorite(pair) { _ in }
    }
}

extension DataRepository {
    struct Dependencies {
        let favoriteDataProvider: FavoriteDataProvidable
        let networkProvider: NetworkProvidable
    }
}

extension DataRepository.Dependencies {
    static func `default`() -> Self {
        return .init(
            favoriteDataProvider: FavoriteDataProvider(),
            networkProvider: NetworkProvider()
        )
    }
}

enum DataOperationError: LocalizedError {
    case missingData(message: String?, code: Int)
}
