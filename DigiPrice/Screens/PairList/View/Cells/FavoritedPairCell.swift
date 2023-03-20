//
//  FavoritedPairCell.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 18.03.2023.
//

import UIKit

final class FavoritedPairCell: UICollectionViewCell {
    @IBOutlet private weak var pairNameLabel: UILabel!
    @IBOutlet private weak var lastPriceLabel: UILabel!
    @IBOutlet private weak var dailyPercentLabel: UILabel!
    
    func setup(_ item: PairDisplayItem) {
        pairNameLabel.text = item.name
        lastPriceLabel.text = item.lastPrice
        dailyPercentLabel.text = item.dailyPercent
        dailyPercentLabel.textColor = UIColor(named: item.dailyPercentColorName)
    }
}
