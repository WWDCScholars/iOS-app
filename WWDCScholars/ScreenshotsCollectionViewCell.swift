//
//  ScreenshotsCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

protocol ImageTappedDelegate {
    func showFullScreenImage(imageView: UIImageView)
}

class ScreenshotsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: ImageTappedDelegate?
    
    override func awakeFromNib() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScreenshotsCollectionViewCell.showFullScreenImage))
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Internal functions
    
    internal func showFullScreenImage() {
        self.delegate?.showFullScreenImage(self.imageView)
    }
}
