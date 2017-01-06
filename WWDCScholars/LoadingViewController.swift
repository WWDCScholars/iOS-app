//
//  LoadingViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 29/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var loadingLabel: UILabel!
    
    var loadingMessage: String? {
        didSet {
            self.loadingLabel.text = self.loadingMessage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    fileprivate func styleUI() {
        self.view.alpha = 0.0
        self.loadingLabel.textColor = UIColor.mediumBlackTextColor()
    }
    
    func startAnimating() {
        self.view.layer.removeAllAnimations()
        self.activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
            self?.view.alpha = 1.0
        }) 
    }
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating
    }
    
    func stopAnimating() {
        self.view.layer.removeAllAnimations()
        self.activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
            self?.view.alpha = 0.0
        }, completion: { [weak self](finished) -> Void in
            self?.view.isHidden = finished
        }) 
    }
}
