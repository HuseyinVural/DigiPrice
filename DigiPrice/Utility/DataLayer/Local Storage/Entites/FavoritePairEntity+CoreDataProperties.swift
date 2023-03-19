//
//  FavoritePairEntity+CoreDataProperties.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 19.03.2023.
//
//

import Foundation
import CoreData


extension FavoritePairEntity: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePairEntity> {
        return NSFetchRequest<FavoritePairEntity>(entityName: "FavoritePairEntity")
    }

    @NSManaged public var pair: String
}
