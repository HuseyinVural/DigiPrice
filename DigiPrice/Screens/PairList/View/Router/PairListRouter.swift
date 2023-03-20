//
//  PairListRouter.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

protocol PairListRoutable: AlertHandler, AnyObject {
    var controller: UIViewController? { get set }
    func showChart(with pair: PairDisplayItem)
}

final class PairListRouter: PairListRoutable {
    weak var controller: UIViewController?
    
    func showChart(with pair: PairDisplayItem) {
        let chartController = Controllers.pairChart(pair: pair).controller
        controller?.navigationController?.pushViewController(chartController, animated: true)
    }
}
