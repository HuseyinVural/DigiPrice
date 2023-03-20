//
//  Controllers.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

enum Controllers {
    case currencyList
    case currencyDetail
    
    var controller: UIViewController {
        switch self {
        case .currencyList:
            let viewModel = CurrencyListViewModel(dataRepository: DataRepository.shared)
            return CurrencyListViewController(dependencies: .default(viewModel: viewModel))
        case .currencyDetail:
            return UIViewController()
        }
    }
}
