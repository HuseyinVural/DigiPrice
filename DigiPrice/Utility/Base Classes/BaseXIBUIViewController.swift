//
//  BaseXIBUIViewController.swift
//  DigiPrice
//
//  Created by Hüseyin Vural on 20.03.2023.
//

import UIKit

open class BaseXIBUIViewController: UIViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    public init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: Self.self))
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
