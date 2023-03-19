//
//  FavoritePairEntity+CoreDataClass.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 19.03.2023.
//
//

import Foundation
import CoreData

@objc(FavoritePairEntity)
public class FavoritePairEntity: NSManagedObject {}

extension FavoritePairEntity {
    /// An enumeration of predefined predicates for `FavoritePairEntity`.
    enum Predicates {
        /// - Parameter pair: The name of the favorite pair to retrieve. Like:  **BTCTRY**
        /// - Returns: An `NSPredicate` owner case that can be used to fetch the corresponding favorite pair.
        case get(pair: String)
        
        /// The predicate query for the associated case.
        var query: NSPredicate {
            switch self {
            case .get(let pair):
                return NSPredicate(format: "pair == %@", argumentArray: [pair])
            }
        }
    }
}
