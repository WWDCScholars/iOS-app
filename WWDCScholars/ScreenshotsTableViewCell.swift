//
//  ScreenshotsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

enum ScreenshotType: Int {
    case Scholarship
    case AppStore
}

class ScreenshotsTableViewCell: UITableViewCell, UICollectionViewDelegate, ImageTappedDelegate {
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var screenshotType: ScreenshotType = .Scholarship
    private var appStoreScreenshots: [URL] = []
    
    var scholarshipScreenshots: [URL] = []
    var delegate: ImageTappedDelegate?
    
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.segmentedControl.applyScholarsSegmentedStyle()
        
        self.retrieveAppStoreScreenshots()
    }
    
    internal func showFullScreenImage(imageView: UIImageView) {
        self.delegate?.showFullScreenImage(imageView)
    }
    
    private func retrieveAppStoreScreenshots() {
        let appStoreURL = "https://itunes.apple.com/gb/app/mouse-times-florida/id1021402097?mt=8"
        let appID = String().matchesForRegexInText("([\\d]{10,})", text: appStoreURL).first
        let lookupURL = "http://itunes.apple.com/lookup?id=\(appID!)"
        
        request(.GET, lookupURL).responseString() { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                
                if let results = json["results"].array {
                    for appJson in results {
                        if let appStoreScreenshots = appJson["screenshotUrls"].array {
                            for screenshot in appStoreScreenshots {
                                if let screenshotString = screenshot.string {
                                    self.appStoreScreenshots.append(URL(screenshotString))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        self.screenshotType = ScreenshotType(rawValue: self.segmentedControl.selectedSegmentIndex) ?? .Scholarship
        
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ScreenshotsTableViewCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshotType == .Scholarship ? self.scholarshipScreenshots.count : self.appStoreScreenshots.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("screenshotsCollectionViewCell", forIndexPath: indexPath) as! ScreenshotsCollectionViewCell
        let screenshot = NSURL(string: self.screenshotType == .Scholarship ? self.scholarshipScreenshots[indexPath.item] : self.appStoreScreenshots[indexPath.item])
        
        if screenshot != nil {
            cell.imageView.af_setImageWithURL(screenshot!, placeholderImage: nil, imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
        }
        
        cell.delegate = self
        
        return cell
    }
}
