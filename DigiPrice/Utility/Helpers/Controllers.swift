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
 let controller = Controllers.currencyDetail(pair: item).controller
 self.navigationController?.pushViewController(controller, animated: true)
 ````
*/
enum Controllers {
    case currencyList
    case currencyDetail(pair: PairDisplayItem)
    
    var controller: UIViewController {
        switch self {
        case .currencyList:
            let viewModel = CurrencyListViewModel(dataRepository: DataRepository.shared, logger: Logger())
            return CurrencyListViewController(dependencies: .default(viewModel: viewModel))
        case .currencyDetail(let pair):
            let viewModel = CurrencyDetailViewModel(pair: pair, dataRepository: DataRepository.shared, logger: Logger())
            return CurrencyDetailViewController(viewModel: viewModel)
        }
    }
}
