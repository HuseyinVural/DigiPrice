//
//  CurrencyListRouter.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

protocol CurrencyListRoutable: AlerHandler {
    var controller: UIViewController? { get set }
    func showChart(with pair: PairDisplayItem)
}

class CurrencyListRouter: CurrencyListRoutable {
    weak var controller: UIViewController?
    
    func showChart(with pair: PairDisplayItem) {
        let chartController = Controllers.currencyDetail(pair: pair).controller
        controller?.navigationController?.pushViewController(chartController, animated: true)
    }
}
