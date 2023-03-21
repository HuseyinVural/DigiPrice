//
//  PairChartViewModel.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import Foundation
import Charts

protocol PairChartViewModelable: AnyObject {
    var didGetChartData: ((_ data: LineChartDataSet) -> Void)! { get set }
    var didGetNavigationBarTitle: ((_ title: String) -> Void)! { get set }
    func viewDidLoad()
}

final class PairChartViewModel: PairChartViewModelable {
    private let pair: PairDisplayItem
    private var dataRepository: ChartRepositoryProtocol
    private var logger: ErrorLoggable
    
    var didGetChartData: ((_ data: LineChartDataSet) -> Void)!
    var didGetNavigationBarTitle: ((_ title: String) -> Void)!

    /**
     Initializes a new `PairChartViewModel`.

     - parameter pair: A `PairDisplayItem` that contains information about the currency pair to display.
     - parameter dataRepository: A `ChartRepositoryProtocol`, it can provide from one of data repository instance
     */
    init(
        pair: PairDisplayItem,
        dataRepository: ChartRepositoryProtocol,
        logger: ErrorLoggable
    ) {
        self.pair = pair
        self.dataRepository = dataRepository
        self.logger = logger
    }
    
    /**
     Called when the view has loaded. Fetches data and updates the navigation bar title.

     Calls `fetch()` and `didGetNavigationBarTitle(_:)`.
     */
    func viewDidLoad() {
        didGetNavigationBarTitle(pair.numeratorSymbol + "/" + pair.denominatorSymbol + " Chart")
        fetch()
    }
    
    /**
     Fetches chart data from the repository and creates a `LineChartDataSet`.

     Calls `dataRepository.getChartDetail(symbol:resolution:from:to:)` and `makeChartData(x:y:)`.

     - throws: An error if fetching the chart data fails, Errors are sent to the logging tool

     - returns: A `LineChartDataSet` that represents the chart data.
     */
    private func fetch() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let now = Date()
                let from = Calendar.current.date(byAdding: .day, value: -3, to: now)
                let data = try await dataRepository.getChartDetail(
                    symbol: pair.symbol,
                    resolution: 60,
                    from: Int(from!.timeIntervalSince1970),
                    to: Int(now.timeIntervalSince1970)
                )
                
                let chartData = makeChartData(x: data.time, y: data.close)
                await MainActor.run {
                    didGetChartData(chartData)
                }
            } catch {
                self.logger.log(error, with: ["PAIR": pair.symbol])
            }
        }
    }
    
    /**
     Creates a `LineChartDataSet` from the given time and close values.

     - parameter time: An array of `Double`s that represent the time values for the chart and it will use x origin
     - parameter close: An array of `Double`s that represent the close values for the chart and it will use y origin

     - returns: A `LineChartDataSet` that represents the chart data.
     */
    private func makeChartData(x time: [Double], y close: [Double]) -> LineChartDataSet {
        var chartData: [ChartDataEntry] = []
        
        for (i, y) in close.enumerated() {
            let timePair = time[i]
            chartData.append(.init(x: timePair, y: y))
        }

        return LineChartDataSet(entries: chartData)
    }
}
