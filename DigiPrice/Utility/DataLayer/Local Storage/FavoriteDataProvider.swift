//
//  FavoriteDataProvider.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation
import CoreData

protocol FavoriteDataProvidable {
    func getFavorites(completion: @escaping (Result<[String], Error>) -> Void)
    func setFavorite(_ pair: String)
    func removeFavorite(_ pair: String, completion: @escaping (Result<String, Error>) -> Void)
}

/**
 The class that provides methods for getting, setting, and removing favorites with using core data.
 This tool is not designed to **save changes to NSManagedObjectContext realtime**.
 Considering the features currently found in this example project, **the NSManagedObjectContext changes are saved when the user is not interacting**.
 */
final class FavoriteDataProvider: FavoriteDataProvidable {
    private let mainContext: NSManagedObjectContext
    private let logger: ErrorLoggable?
    
    /**
     - Parameters:
     - mainContext: The `NSManagedObjectContext` to be used as the main context.
     - logger: The `ErrorLoggable` logger to be used to log errors.
     */
    public init(
        _ mainContext: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext,
        logger: ErrorLoggable? = Logger()
    ) {
        self.mainContext = mainContext
        self.logger = logger
    }
    
    public func getFavorites(completion: @escaping (Result<[String], Error>) -> Void) {
        let req: NSFetchRequest<FavoritePairEntity> = FavoritePairEntity.fetchRequest()
        req.fetchLimit = 200
        mainContext.performAndWait { [weak self] in
            guard let self else {
                return
            }
            
            do {
                let objects = try req.execute()
                let pairs = objects.map({ $0.pair }).compactMap({ $0 })
                completion(.success(pairs))
            } catch {
                completion(.failure(error))
                self.logger?.log(error, with: ["info": "Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    /**
     Adds the given pair to favorites.
     
     - Parameters:
     - pair: The pair to be added. It can be currency pair like **BTCUSDT**
     */
    public func setFavorite(_ pair: String) {
        mainContext.perform { [weak self] in
            guard let self else { return }
            let entity = FavoritePairEntity(context: self.mainContext)
            entity.pair = pair
            self.mainContext.insert(entity)
        }
    }
    
    /**
     Removes the given pair from favorites.
     
     - Parameters:
     - pair: The pair to be removed.
     - completion: The completion block that will be called when the pair is removed.
     */
    public func removeFavorite(_ pair: String, completion: @escaping (Result<String, Error>) -> Void) {
        let req: NSFetchRequest<FavoritePairEntity> = FavoritePairEntity.fetchRequest()
        req.predicate = FavoritePairEntity.Predicates.get(pair: pair).query
        req.fetchLimit = 1
        mainContext.performAndWait { [weak self] in
            guard let self else {
                return
            }
            
            do {
                if let object = try req.execute().first {
                    self.mainContext.delete(object)
                }
                completion(.success(pair))
            } catch {
                completion(.failure(error))
                logger?.log(error, with: ["info": "Function: \(#function), line: \(#line)"])
            }
        }
    }
}
