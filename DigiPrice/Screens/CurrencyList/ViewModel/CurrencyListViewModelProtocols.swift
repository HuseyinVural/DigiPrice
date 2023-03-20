//
//  CurrencyListViewModelProtocols.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

protocol CurrencyListViewModelable: CurrencyListViewModelDataManageable, AnyObject {
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
