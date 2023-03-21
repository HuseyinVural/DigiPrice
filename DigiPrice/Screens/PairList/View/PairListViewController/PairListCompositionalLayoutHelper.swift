//
//  PairListCompositionalLayoutHelper.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

/**
 - It ensures that the following view remains independent from the layout creator.
*/
protocol CompositionalLayoutFactory {
    func layout() -> UICollectionViewCompositionalLayout
}

/**
 - Layout schema injectable into any view
*/
final class PairListCompositionalLayoutHelper: CompositionalLayoutFactory {
    private let viewModel: PairListViewModelDataManageable
    
    init(viewModel: PairListViewModelDataManageable) {
        self.viewModel = viewModel
    }

    /**
     - If the number of sections is one, it creates only vertical flow.
    */
    public func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [unowned self] (section, environment) -> NSCollectionLayoutSection? in
            if self.viewModel.numberOfSections() < 2 {
                return self.createPairsSectionLayout()
            }
            
            switch section {
            case 0:
                return self.createFavoritesSectionLayout()
            default:
                return self.createPairsSectionLayout()
            }
        }
    }
    
    /**
     - Creates a header that contains PairSectionHeaderView.
    */
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
        return .init(layoutSize: size, elementKind: PairSectionHeaderView.reuseIdentifier, alignment: .top)
    }
    
    /**
     - Creates a collection view with fixed height sliding to the right.
     - It has a header.
    */
    private func createFavoritesSectionLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 10, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4.8), heightDimension: .absolute(76))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 18
        let header = createSectionHeader()
        if #available(iOS 15.0, *) {
            header.contentInsets.leading = -10
        }
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    /**
     - Creates a vertical collection view flow with full width sliding to the bottom.
     - It has a header.
    */
    private func createPairsSectionLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let section = NSCollectionLayoutSection(group: .vertical(layoutSize: groupSize, subitems: [item]))
        let header = createSectionHeader()
        header.contentInsets.leading = 8
        section.boundarySupplementaryItems = [header]
        return section
    }
}
