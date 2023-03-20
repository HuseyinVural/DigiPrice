//
//  PairListViewModel.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

final class PairListViewModel: PairListViewModelable {
    typealias DataLayerProtocol = PairsRepositoryProtocol & FavoritesRepositoryProtocol
    
    private var dataRepository: DataLayerProtocol
    private var logger: ErrorLoggable
    private var favoritedPairList: [PairDisplayItem] = [.init(isRising: false)]
    private var pairList: [PairDisplayItem] = [.init(isRising: true)]
    private var favoritesMap: [AnyHashable: PairDisplayItem] = [:]
    private var sections: [PairListSection] = []
    
    var reload: (() -> Void)!
    var showCollection: (() -> Void)!
    var showPairChart: ((_ pair: PairDisplayItem) -> Void)!
    var showDataOperationFail: AlertClosureSignature!
    
    init(dataRepository: DataLayerProtocol, logger: ErrorLoggable) {
        self.logger = logger
        self.dataRepository = dataRepository
    }
    
    func viewDidLoad() {
        fetch()
    }
    
    /**
     Toggles the favorite state of a currency pair and saves the changes.
     
     - Parameter indexPath: The index path of the currency pair.
     */
    func tapFavoriteButton(_ indexPath: IndexPath) {
        let pair = getPairDisplayItem(from: indexPath)
        
        if pair.isPlaceholder {
            return
        }
        
        if let item = favoritesMap[pair.symbol] {
            dataRepository.removeFavorite(pair.symbol)
            item.isFavorited = false
            favoritesMap.removeValue(forKey: pair.symbol)
            favoritedPairList.removeAll(where: { $0.symbol == pair.symbol })
        } else {
            dataRepository.setFavorite(pair.symbol)
            favoritedPairList.append(pair)
            favoritesMap[pair.symbol] = pair
            pair.isFavorited = true
        }
        
        updateSections()
        reload()
    }
    
    /**
     Selects the specified pair and shows its chart.
     Parameter indexPath: The index path of the selected pair that use finding from raw data list.
     */
    func didSelectPair(_ indexPath: IndexPath) {
        let pair = getPairDisplayItem(from: indexPath)
        
        if pair.isPlaceholder {
            return
        }
        
        showPairChart(pair)
    }
}

// MARK: - Private utils functions
extension PairListViewModel {
    
    /**
     Fetches pairs and favorites from the data repository and populates the view model's pairList and favoritedPairList properties.
     - That invokes reload action in main thread after set all datasource settings.
     - If it is failed, It logging that case and show error message for send data process again
     */
    private func fetch() {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            do {
                let pairs = try await self.dataRepository.getPairs(symbol: nil)
                let favorites = try await self.dataRepository.getFavorites()
                
                pairs.forEach { item in
                    let isFavorited = favorites.contains(item.pair)
                    let displayItem: PairDisplayItem = .init(data: item, isFavorited: isFavorited)
                    self.pairList.append(displayItem)
                    if isFavorited {
                        self.favoritesMap[displayItem.symbol] = displayItem
                        self.favoritedPairList.append(displayItem)
                    }
                }
                
                self.updateSections()
                
                await MainActor.run {
                    self.reload()
                    self.showCollection()
                }
            } catch {
                self.logger.log(error, with: [:])
                await MainActor.run {
                    self.showDataOperationFail("Retry", error.localizedDescription) {
                        self.fetch()
                    }
                }

            }
        }
    }
    
    /**
        Returns the corresponding PairDisplayItem for the given IndexPath.
     
        - parameter indexPath: The IndexPath of the item to retrieve.
        - returns: The PairDisplayItem corresponding to the given IndexPath.
    */
    private func getPairDisplayItem(from indexPath: IndexPath) -> PairDisplayItem {
        switch getSectionType(section: indexPath.section) {
        case .favorites:
            return favoritedPairList[indexPath.row]
        case .pairs:
            return pairList[indexPath.row]
        }
    }
    
    
    /**
        Check section status, Should be call when data change.
    */
    private func updateSections() {
        sections.removeAll()
        if favoritedPairList.count > 1 {
            sections.append(.favorites)
        }
        
        if pairList.count > 1 {
            sections.append(.pairs)
        }
    }
}

// MARK: - PairListViewModelDataManageable, responsible for data needs
extension PairListViewModel {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func collectionView(numberOfItemsInSection section: Int) -> Int {
        switch getSectionType(section: section) {
        case .favorites:
            return favoritedPairList.count
        case .pairs:
            return pairList.count
        }
    }
    
    func collectionView(cellForItemAt indexPath: IndexPath) -> PairDisplayItem {
        return getPairDisplayItem(from: indexPath)
    }
    
    func getSectionTitle(section: Int) -> String {
        switch getSectionType(section: section) {
        case .favorites:
            return "Favorites"
        case .pairs:
            return "Pairs"
        }
    }
    
    func getSectionType(section: Int) -> PairListSection {
        return sections[section]
    }
}
