//
//  CurrencyListDatasource.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

/**
    -  A `UICollectionViewDataSource` that provides data to display on a currency list.
    - It is used to soften the dependency in the View and contribute to the testing process.
    - Note: This class is not thread-safe, and should be accessed from the main thread only.
 */
final class CurrencyListDatasource: NSObject, UICollectionViewDataSource {
    private var viewModel: CurrencyListViewModelDataManageable
    
    init(viewModel: CurrencyListViewModelDataManageable) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectionView(numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.collectionView(cellForItemAt: indexPath)
        switch indexPath.section {
        case 0 where viewModel.numberOfSections() > 1:
            let cell: FavoritedPairCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(item)
            return cell
        default:
            let cell: PairCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(item) { [weak self] in
                self?.viewModel.tapFavoriteButton(indexPath)
            }
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view: PairSectionHeaderView = collectionView.dequeueReusableSupplementaryView(for: kind, at: indexPath)
        view.setup(title: viewModel.getSectionTitle(section: indexPath.section))
        return view
    }
}
