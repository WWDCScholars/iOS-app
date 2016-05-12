//
//  ActivityIndicatorView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 15/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.loadingLabel.textColor = UIColor.mediumTextColor()
    }
    
    func startAnimating() {
        self.layer.removeAllAnimations()
        self.activityIndicator.startAnimating()
        self.hidden = false
        
        UIView.animateWithDuration(0.2) { [weak self]() -> Void in
            self?.alpha = 1.0
        }
    }
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating()
    }
    
    func stopAnimating() {
        self.layer.removeAllAnimations()
        self.hidden = false
        self.alpha = 1.0
        self.activityIndicator.stopAnimating()
        
        UIView.animateWithDuration(0.2, animations: { [weak self]() -> Void in
            self?.alpha = 0.0
        }) { [weak self](finished) -> Void in
            self?.hidden = finished
        }
    }
}
