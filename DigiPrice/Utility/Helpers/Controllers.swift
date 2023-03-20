//
//  Controllers.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

/**
 Returns the appropriate UIViewController based on the current enum case.

 - Returns: A new instance of the appropriate UIViewController.

 ````
 let controller = Controllers.pairChart(pair: item).controller
 self.navigationController?.pushViewController(controller, animated: true)
 ````
*/
enum Controllers {
    case pairList
    case pairChart(pair: PairDisplayItem)
    
    var controller: UIViewController {
        switch self {
        case .pairList:
            let viewModel = PairListViewModel(dataRepository: DataRepository.shared, logger: Logger())
            return PairListViewController(dependencies: .default(viewModel: viewModel))
        case .pairChart(let pair):
            let viewModel = PairChartViewModel(pair: pair, dataRepository: DataRepository.shared, logger: Logger())
            return PairChartViewController(viewModel: viewModel)
        }
    }
}
