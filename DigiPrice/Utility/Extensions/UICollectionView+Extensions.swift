//
//  UICollectionView+Extensions.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

extension UICollectionView {
    
    /// Registers the nibs for the specified header views as supplementary views for the corresponding reuseIdentifier and kind.
    ///
    /// - Parameter types: The UIView types for the header views to register.
    /// - It can be supported variadic format, you can pass multiple or single parameter
    func registerHeaders(_ types: UIView.Type...) {
        types.forEach {
            register(
                $0.nib,
                forSupplementaryViewOfKind: $0.reuseIdentifier,
                withReuseIdentifier: $0.reuseIdentifier
            )
        }
    }
    
    /// Registers the nibs for the specified cell types.
    ///
    /// - Parameter types: The UICollectionViewCell types to register.
    /// - It can be supported variadic format, you can pass multiple or single parameter
    func registerCells(_ types: UICollectionViewCell.Type...) {
        types.forEach {
            register($0.nib, forCellWithReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
    /// Dequeues a reusable supplementary view of the specified type.
    ///
    /// - Parameters:
    ///   - kind: The kind of supplementary view to dequeue.
    ///   - indexPath: The index path specifying the location of the supplementary view in the collection view.
    ///
    /// - Returns: A reusable supplementary view of the specified type.
    func dequeueReusableSupplementaryView<T: UIView>(for kind: String, at indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    /// Dequeues a reusable cell of the specified type.
    ///
    /// - Parameter indexPath: The index path specifying the location of the cell in the collection view.
    ///
    /// - Returns: A reusable cell of the specified type.
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
