//
//  PairListDelegate.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

/**
    -  A `UICollectionViewDelegate` that provides data to display on a  list.
    - It is used to soften the dependency in the View and contribute to the testing process.
    - Note: This class is not thread-safe, and should be accessed from the main thread only.
 */
final class PairListDelegate: NSObject, UICollectionViewDelegate {
    private let viewModel: PairListViewModelSelectionManageable
    
    init(viewModel: PairListViewModelSelectionManageable) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectPair(indexPath)
    }
}
