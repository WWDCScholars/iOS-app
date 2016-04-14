//
//  ViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 27.02.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

enum YearScrollDirection {
    case Left
    case Right
}

class ScholarsViewController: UIViewController {
    @IBOutlet private weak var yearCollectionView: UICollectionView!
    @IBOutlet private weak var scholarsCollectionView: UICollectionView!
    @IBOutlet private weak var extendedNavigationContainer: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mapView: UIView!
    @IBOutlet private weak var rightArrowImageView: UIImageView!
    @IBOutlet private weak var leftArrowImageView: UIImageView!
    
    let years: [WWDC] = [.WWDC2011, .WWDC2012, .WWDC2013, .WWDC2014, .WWDC2015, .WWDC2016]
    var scholars: [Scholar] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.scrollViewDidEndDecelerating(self.yearCollectionView)
        
        ScholarsAPI.sharedInstance.loadScholars({
            self.scholars = DatabaseManager.sharedInstance.getAllScholars()
            self.scholarsCollectionView.reloadData()
        })
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Scholars"
        
        self.extendedNavigationContainer.applyExtendedNavigationBarContainerStyle()
        self.applyExtendedNavigationBarStyle()
        self.leftArrowImageView.tintColor = UIColor.transparentWhiteColor()
        self.rightArrowImageView.tintColor = UIColor.transparentWhiteColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - IBAction
    
    @IBAction func mapButtonTapped(sender: AnyObject) {
        if self.mapView.hidden == true {
            self.mainView.hidden = true
            self.mapView.hidden = false
        } else {
            self.mapView.hidden = true
            self.mainView.hidden = false
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //scholarsCollectionView page changed, update scholars list
        
        let currentIndex = Int(self.yearCollectionView.contentOffset.x / self.yearCollectionView.frame.size.width)
        
        UIView.animateWithDuration(0.2, animations: {
            self.leftArrowImageView.alpha = currentIndex == 0 ? 0.0 : 1.0
            self.rightArrowImageView.alpha = currentIndex == self.years.count - 1 ? 0.0 : 1.0
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.2, animations: {
            self.leftArrowImageView.alpha = 0.0
            self.rightArrowImageView.alpha = 0.0
        })
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.scholarsCollectionView {
            return self.scholars.count
        } else if collectionView == self.yearCollectionView {
            return self.years.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.scholarsCollectionView {
            let cell = self.scholarsCollectionView.dequeueReusableCellWithReuseIdentifier("scholarCollectionViewCell", forIndexPath: indexPath) as! ScholarCollectionViewCell
            let scholar = self.scholars[indexPath.item]
            
            cell.nameLabel.text = scholar.fullName
            cell.profileImageView.image = UIImage(named: "Matthijs Logemann")
            
            return cell
        } else if collectionView == self.yearCollectionView {
            let cell = self.yearCollectionView.dequeueReusableCellWithReuseIdentifier("yearCollectionViewCell", forIndexPath: indexPath) as! YearCollectionViewCell
            
            cell.yearLabel.text = self.years[indexPath.item].rawValue
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ScholarsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == self.scholarsCollectionView {
            return CGSize(width: (self.scholarsCollectionView.frame.size.width / 3.0) - 8.0, height: 140.0)
        } else if collectionView == self.yearCollectionView {
            return CGSize(width: self.yearCollectionView.frame.size.width, height: 50.0)
        }
        
        return CGSize.zero
    }
}