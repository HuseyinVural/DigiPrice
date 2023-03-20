//
//  PairCell.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 18.03.2023.
//

import UIKit

final class PairCell: UICollectionViewCell {
    private var favoriteAction: (() -> Void)?
    
    @IBOutlet private weak var favoriteIconImageView: UIImageView!
    @IBOutlet private weak var pairNameLabel: UILabel!
    @IBOutlet private weak var lastPriceLabel: UILabel!
    @IBOutlet private weak var dailyPercentLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    
    func setup(_ item: PairDisplayItem, action: (() -> Void)?) {
        favoriteAction = action
        pairNameLabel.text = item.name
        lastPriceLabel.text = item.lastPrice
        dailyPercentLabel.text = item.dailyPercent
        volumeLabel.text = item.volume
        favoriteIconImageView.tintColor = UIColor(named: item.favoriteIconColorName)
        dailyPercentLabel.textColor = UIColor(named: item.dailyPercentColorName)
    }
    
    @IBAction
    private func tapFavoriteButtonAction(_ sender: Any) {
        favoriteAction?()
    }
}
