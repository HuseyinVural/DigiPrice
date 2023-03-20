//
//  PairSectionHeaderView.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 18.03.2023.
//

import UIKit

final class PairSectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setup(title: String) {
        titleLabel.text = title
    }
}
