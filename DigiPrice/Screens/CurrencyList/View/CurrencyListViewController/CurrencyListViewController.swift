//
//  CurrencyListViewController.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

final class CurrencyListViewController: BaseXIBUIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    private let viewModel: CurrencyListViewModelable
    private let router: CurrencyListRoutable
    private let datasource: UICollectionViewDataSource?
    private let collectionDelegate: UICollectionViewDelegate?
    private let compositionalLayoutFactory: CompositionalLayoutFactory
    
    // MARK: - Lifecycle Methods
    init(dependencies: Dependencies) {
        self.viewModel = dependencies.model
        self.datasource = dependencies.datasource
        self.collectionDelegate = dependencies.collectionDelegate
        self.compositionalLayoutFactory = dependencies.compositionalLayoutFactory
        self.router = CurrencyListRouter()
        super.init()
        self.router.controller = self
        self.bindViewModelProperties()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        applyCollectionViewSettings()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Private helpers
extension CurrencyListViewController {
    private func applyCollectionViewSettings() {
        collectionView.registerCells(FavoritedPairCell.self, PairCell.self)
        collectionView.registerHeaders(PairSectionHeaderView.self)
        collectionView.dataSource = datasource
        collectionView.delegate = collectionDelegate
        collectionView.collectionViewLayout = compositionalLayoutFactory.layout()
        collectionView.reloadData()
    }
    
    private func bindViewModelProperties() {
        viewModel.reload = reload()
        viewModel.showCollection = showCollection()
        viewModel.showPairChart = showPairChart()
        viewModel.showDataOperationFail = showDataOperationFail()
    }
    
    private func reload() -> () -> Void {
        return { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func showPairChart() -> (_ pair: PairDisplayItem) -> Void {
        return { [weak self] pair in
            self?.router.showChart(with: pair)
        }
    }
    
    private func showCollection() -> () -> Void {
        return { [weak self] in
            UIView.animate(withDuration: 1) {
                self?.collectionView.alpha = 1
            }
            
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    private func showDataOperationFail() -> AlertClosureSignature {
        return { [weak self] actionTitle, message, action in
            if let self {
                self.router.showError(.init(controller: self, actionTitle: actionTitle, message: message), completion: action)
            }
        }
    }
}

// MARK: - Quick initial/injection environment
extension CurrencyListViewController {
    struct Dependencies {
        let model: CurrencyListViewModelable
        let datasource: UICollectionViewDataSource
        let collectionDelegate: UICollectionViewDelegate
        let compositionalLayoutFactory: CompositionalLayoutFactory
    }
}

extension CurrencyListViewController.Dependencies {
    static func `default`(viewModel: CurrencyListViewModelable) -> Self {
        return .init(
            model: viewModel,
            datasource: CurrencyListDatasource(viewModel: viewModel),
            collectionDelegate: CurrencyListDelegate(viewModel: viewModel),
            compositionalLayoutFactory: CurrencyListCompositionalLayoutHelper(viewModel: viewModel)
        )
    }
}
