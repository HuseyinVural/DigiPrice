//
//  PairChartViewController.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit
import Charts

final class PairChartViewController: BaseXIBUIViewController, UIGestureRecognizerDelegate {
    // MARK: - Outlets
    @IBOutlet private weak var chartView: LineChartView!
    
    // MARK: - Variables
    private let viewModel: PairChartViewModelable
    
    // MARK: - Lifecycle Methods
    init(viewModel: PairChartViewModelable) {
        self.viewModel = viewModel
        super.init()
        self.bindViewModelProperties()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        applyInitialChartSettings()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Private Utils
extension PairChartViewController {
    private func applyInitialChartSettings() {
        let rAxis = chartView.rightAxis
        rAxis.setLabelCount(6, force: false)
        rAxis.labelTextColor = .white
        rAxis.labelPosition = .outsideChart
        rAxis.axisLineColor = .clear
        rAxis.gridColor = .white.withAlphaComponent(0.1)
        
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.backgroundColor = UIColor(named: AppColors.secondaryBackgroundColor.rawValue)
    }
    
    private func bindViewModelProperties() {
        viewModel.didGetChartData = didGetChartData()
        viewModel.didGetNavigationBarTitle = didGetNavigationBarTitle()
    }
    
    private func didGetChartData() -> (_ chartData: LineChartDataSet) -> Void {
        return { [weak self] chartData in
            self?.parseChartData(chartData)
        }
    }
    
    private func didGetNavigationBarTitle() -> (_ title: String) -> Void {
        return { [weak self] title in
            self?.insetStandAloneNavigationBar(title)
        }
    }
    
    private func insetStandAloneNavigationBar(_ title: String){
        let item = UINavigationItem()
        item.title = title
        
        let backItem = UIBarButtonItem(
            image: UIImage(named: "navigationBack"),
            style: .plain,
            target: navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        
        item.leftBarButtonItem = backItem
        
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .clear
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.barStyle = .default
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        navigationBar.bottomAnchor.constraint(equalTo: chartView.topAnchor, constant: -16).isActive = true

        navigationBar.items = [item]
    }
    
    private func parseChartData(_ line: LineChartDataSet) {
        let chartColor = UIColor(named: AppColors.chartTintColor.rawValue)!
        let secondColor = UIColor(named: AppColors.secondaryBackgroundColor.rawValue)!
        line.colors = [chartColor]
        line.mode = .cubicBezier
        line.drawCirclesEnabled = false
        line.lineWidth = 2
        line.circleRadius = 4
        line.fillAlpha = 0.8
        line.highlightColor = .white
        line.drawHorizontalHighlightIndicatorEnabled = false
        line.drawFilledEnabled = true
        
        let gradientColors = [secondColor.cgColor, chartColor.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        line.fill = LinearGradientFill(gradient: gradient, angle: 90)
        
        
        let data = LineChartData(dataSet: line)
        data.setDrawValues(false)
        
        let lineChartData = LineChartData(dataSet: line)
        
        chartView.data = lineChartData
    }
}

