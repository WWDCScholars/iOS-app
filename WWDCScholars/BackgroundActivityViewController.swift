//
//  BackgroundActivityViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BackgroundActivityViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var label: UILabel?
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet private weak var containerView: UIView?
    
    // MARK: - Internal Properties
    
    internal var text: String?
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.backgroundColor = .clear
        self.containerView?.backgroundColor = .clear
        self.activityIndicator?.color = .backgroundElementGray
        self.label?.applyBackgroundTitleStyle()
    }
    
    private func configureUI() {
        self.activityIndicator?.startAnimating()
        self.label?.isHidden = self.text?.isEmpty == true
        self.label?.text = self.text
    }
}
