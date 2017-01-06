//
//  ScreenshotsCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

protocol ImageTappedDelegate {
    func showFullScreenImage(_ imageView: UIImageView)
}

class ScreenshotsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: ImageTappedDelegate?
    
    override func awakeFromNib() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScreenshotsCollectionViewCell.showFullScreenImage))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Internal functions
    
    internal func showFullScreenImage() {
        self.delegate?.showFullScreenImage(self.imageView)
    }
}
