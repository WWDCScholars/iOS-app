//
//  ScreenshotsTableViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 17/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

enum ScreenshotType: Int {
    case scholarship
    case appStore
}

class ScreenshotsTableViewCell: UITableViewCell, UICollectionViewDelegate, ImageTappedDelegate {
    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var noScreenshotsLabel: UILabel!
    
    fileprivate var screenshotType: ScreenshotType = .scholarship
    fileprivate var appStoreScreenshots: [URLString] = []
    fileprivate var appStoreURL = ""
    
    var scholarshipScreenshots: [URLString] = []
    var delegate: ImageTappedDelegate?
    var is2016: Bool = false {
        didSet {
            self.collectionViewTopConstraint.constant = self.is2016 == true ? 60.0 : 16.0
            self.layoutIfNeeded()
            
            if self.is2016 == true {
                segmentedControl.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.segmentedControl.applyScholarsSegmentedStyle()
        
        self.setNoScreenshotsLabelHidden(true)
        self.retrieveAppStoreScreenshots()
    }
    
    func setAppStoreURL(_ url: URLString) {
        self.appStoreURL = url
        self.is2016 = (url == "") ? false : self.is2016
        guard self.appStoreURL != "" else {
            return
        }
        
        self.retrieveAppStoreScreenshots() {
            self.collectionView.reloadData()
        }
    }
    
    internal func showFullScreenImage(_ imageView: UIImageView) {
        self.delegate?.showFullScreenImage(imageView)
    }
    
    fileprivate func retrieveAppStoreScreenshots(_ completionHandler: (() -> Void)? = nil) {
        guard self.appStoreURL != "" else {
            return
        }
        
        let appID = String().matchesForRegexInText("([\\d]{10,})", text: self.appStoreURL).first
        if appID == nil {
            print("App Store URL is shortened version, impossible to retrieve APP ID", self.appStoreURL)
            
            return
        }
        
        let lookupURL = "http://itunes.apple.com/lookup?id=\(appID!)"
        
        request(lookupURL, method: .get).responseString() { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                
                if let results = json["results"].array {
                    for appJson in results {
                        if let appStoreScreenshots = appJson["screenshotUrls"].array {
                            for screenshot in appStoreScreenshots {
                                if let screenshotString = screenshot.string {
                                    self.appStoreScreenshots.append(URLString(screenshotString))
                                    completionHandler?()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Private functions

    func setNoScreenshotsLabelHidden(_ hiddenStatus: Bool) {
        self.noScreenshotsLabel.isHidden = hiddenStatus
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentedControlChanged(_ sender: AnyObject) {
        self.screenshotType = ScreenshotType(rawValue: self.segmentedControl.selectedSegmentIndex) ?? .scholarship
        
        switch self.screenshotType {
        case .scholarship where self.scholarshipScreenshots.count == 0:
            self.setNoScreenshotsLabelHidden(false)
        case .appStore where self.appStoreScreenshots.count == 0:
            self.setNoScreenshotsLabelHidden(false)
        default:
            self.setNoScreenshotsLabelHidden(true)
        }
        
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ScreenshotsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenshotType == .scholarship ? self.scholarshipScreenshots.count : self.appStoreScreenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotsCollectionViewCell", for: indexPath) as! ScreenshotsCollectionViewCell

        let screenshot = Foundation.URL(string: self.screenshotType == .scholarship ? self.scholarshipScreenshots[indexPath.item] : self.appStoreScreenshots[indexPath.item])

        if screenshot != nil {
            cell.activityIndicator.startAnimating()
            cell.imageView.af_setImage(withURL: screenshot!, placeholderImage: nil, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { response in
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.removeFromSuperview()
                
                // Don't cache screenshots
                let imageDownloader = UIImageView.af_sharedImageDownloader
                let urlRequest = Foundation.URLRequest(url: screenshot!)
                //Clear from in-memory cache
                imageDownloader.imageCache?.removeImage(for: urlRequest, withIdentifier: nil)
                //Clear from on-disk cache
                imageDownloader.sessionManager.session.configuration.urlCache?.removeCachedResponse(for: urlRequest)
                
            })
        }
        
        cell.delegate = self
        
        return cell
    }
}


























