//
//  CurrencyListRouter.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

protocol CurrencyListRoutable {
    var controller: UIViewController? { get set }
    func showChart(with pair: PairDisplayItem)
}

class CurrencyListRouter: CurrencyListRoutable {
    weak var controller: UIViewController?
    
    func showChart(with pair: PairDisplayItem) {
        #warning("Add Routing")
    }
}
