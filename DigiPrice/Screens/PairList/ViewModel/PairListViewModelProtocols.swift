//
//  PairListViewModelProtocols.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation

protocol PairListViewModelable: PairListViewModelDataManageable, AnyObject {
    var reload: (() -> Void)! { get set }
    var showCollection: (() -> Void)! { get set }
    var showPairChart: ((_ pair: PairDisplayItem) -> Void)! { get set }
    var showDataOperationFail: AlertClosureSignature! { get set }

    func viewDidLoad()
}

protocol PairListViewModelSelectionManageable {
    func tapFavoriteButton(_ indexPath: IndexPath)
    func didSelectPair(_ indexPath: IndexPath)
}

protocol PairListViewModelDataManageable: PairListViewModelSelectionManageable {
    func numberOfSections() -> Int
    func collectionView(numberOfItemsInSection section: Int) -> Int
    func collectionView(cellForItemAt indexPath: IndexPath) -> PairDisplayItem
    func getSectionTitle(section: Int) -> String
    func getSectionType(section: Int) -> PairListSection
}
