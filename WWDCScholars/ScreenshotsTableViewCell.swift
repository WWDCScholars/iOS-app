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
    
    internal func showFullScreenImage(imageView: UIImageView) {
        self.delegate?.showFullScreenImage(imageView)
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        let appStoreURL = "https://itunes.apple.com/gb/app/mouse-times-florida/id1021402097?mt=8"
        let appID = String().matchesForRegexInText("([\\d]{10,})", text: appStoreURL).first
        let lookupURL = "http://itunes.apple.com/lookup?id=\(appID!)"
        
        if let url = NSURL(string: lookupURL) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                let results: JSON = json["results"]
                
                for (index, object) in results.enumerate() {
                    let screenshots: JSON = json[index]["screenshotUrls"]
                    
                    print(screenshots)
                }
            }
        }
        
        self.screenshots = []
        self.collectionView.reloadData()
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
            cell.imageView.af_setImageWithURL(screenshot!, placeholderImage: nil, imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        }
        
        cell.delegate = self
        
        return cell
    }
}
