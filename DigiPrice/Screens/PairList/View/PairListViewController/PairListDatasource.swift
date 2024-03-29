//
//  PairListDatasource.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

/**
    -  A `UICollectionViewDataSource` that provides data to display on a pair list.
    - It is used to soften the dependency in the View and contribute to the testing process.
    - Note: This class is not thread-safe, and should be accessed from the main thread only.
 */
final class PairListDatasource: NSObject, UICollectionViewDataSource {
    private var viewModel: PairListViewModelDataManageable
    
    init(viewModel: PairListViewModelDataManageable) {
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
        
        switch viewModel.getSectionType(section: indexPath.section) {
        case .favorites:
            let cell: FavoritedPairCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(item)
            return cell
        case .pairs:
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
