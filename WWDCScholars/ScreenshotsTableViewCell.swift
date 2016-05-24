//
//  ScreenshotsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ScreenshotsTableViewCell: UITableViewCell, UICollectionViewDelegate, ImageTappedDelegate {
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var screenshots: [URL] = []
    var delegate: ImageTappedDelegate?
    
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.segmentedControl.applyScholarsSegmentedStyle()
    }
    
    func showFullScreenHeader(imageView: UIImageView) {
        self.delegate?.showFullScreenHeader(imageView)
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
    }
}

// MARK: - UICollectionViewDataSource

extension ScreenshotsTableViewCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshots.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("screenshotsCollectionViewCell", forIndexPath: indexPath) as! ScreenshotsCollectionViewCell
        let screenshot = NSURL(string: self.screenshots[indexPath.item])
        
        if screenshot != nil {
            cell.imageView.af_setImageWithURL(screenshot!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        }
        
        cell.delegate = self
        
        return cell
    }
}
