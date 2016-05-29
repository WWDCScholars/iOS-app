//
//  LoadingViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 29/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.alpha = 0.0
        self.loadingLabel.textColor = UIColor.mediumBlackTextColor()
    }
    
    func startAnimating() {
        self.view.layer.removeAllAnimations()
        self.activityIndicator.startAnimating()
        
        UIView.animateWithDuration(0.2) { [weak self]() -> Void in
            self?.view.alpha = 1.0
        }
    }
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating()
    }
    
    func stopAnimating() {
        self.view.layer.removeAllAnimations()
        self.activityIndicator.stopAnimating()
        
        UIView.animateWithDuration(0.2, animations: { [weak self]() -> Void in
            self?.view.alpha = 0.0
        }) { [weak self](finished) -> Void in
            self?.view.hidden = finished
        }
    }
}
