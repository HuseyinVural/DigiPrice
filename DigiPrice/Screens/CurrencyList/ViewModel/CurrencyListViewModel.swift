//
//  CurrencyListViewModel.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

protocol CurrencyListViewModelable: CurrencyListViewModelDataManageable {
    var reload: (() -> Void)! { get set }
    var showCollection: (() -> Void)! { get set }
    var showPairChart: ((_ pair: PairDisplayItem) -> Void)! { get set }
    var showDataOperationFail: AlertClosureSignature! { get set }

    func viewDidLoad()
}

protocol CurrencyListViewModelSelectionManageable {
    func tapFavoriteButton(_ indexPath: IndexPath)
    func didSelectPair(_ indexPath: IndexPath)
}

protocol CurrencyListViewModelDataManageable: CurrencyListViewModelSelectionManageable {
    func numberOfSections() -> Int
    func collectionView(numberOfItemsInSection section: Int) -> Int
    func collectionView(cellForItemAt indexPath: IndexPath) -> PairDisplayItem
    func getSectionTitle(section: Int) -> String
}

final class CurrencyListViewModel: CurrencyListViewModelable {
    typealias DataLayerProtocol = PairsRepositoryProtocol & FavoritesRepositoryProtocol
    
    private var dataRepository: DataLayerProtocol
    private var favoritedPairList: [PairDisplayItem] = [.init(isRising: false)]
    private var pairList: [PairDisplayItem] = [.init(isRising: true)]
    private var favoritesMap: [AnyHashable: PairDisplayItem] = [:]
    
    var reload: (() -> Void)!
    var showCollection: (() -> Void)!
    var showPairChart: ((_ pair: PairDisplayItem) -> Void)!
    var showDataOperationFail: AlertClosureSignature!
    
    init(dataRepository: DataLayerProtocol) {
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
            CoreDataStack.shared.saveContext()
        } else {
            dataRepository.setFavorite(pair.symbol)
            favoritedPairList.append(pair)
            favoritesMap[pair.symbol] = pair
            pair.isFavorited = true
        }
        
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
extension CurrencyListViewModel {
    
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
                
                await MainActor.run {
                    self.reload()
                    self.showCollection()
                }
            } catch {
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
        var source = indexPath.section == 0 ? favoritedPairList : pairList
        if numberOfSections() == 1 {
            source = pairList
        }
        
        return source[indexPath.row]
    }
}

// MARK: - CurrencyListViewModelDataManageable, responsible for data needs
extension CurrencyListViewModel {
    func numberOfSections() -> Int {
        return favoritedPairList.count > 0 ? 2 : 1
    }
    
    func collectionView(numberOfItemsInSection section: Int) -> Int {
        if numberOfSections() == 1 {
            return pairList.count
        }
        
        return section == 0 ? favoritedPairList.count : pairList.count
    }
    
    func collectionView(cellForItemAt indexPath: IndexPath) -> PairDisplayItem {
        return getPairDisplayItem(from: indexPath)
    }
    
    func getSectionTitle(section: Int) -> String {
        if section == 0 && numberOfSections() > 1 {
            return "Favorites"
        } else {
            return "Pairs"
        }
    }
}
