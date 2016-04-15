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
    @IBOutlet private weak var loadingView: ActivityIndicatorView!
    @IBOutlet private weak var scholarsCollectionView: UICollectionView!
    @IBOutlet private weak var extendedNavigationContainer: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mapView: UIView!
    @IBOutlet private weak var rightArrowImageView: UIImageView!
    @IBOutlet private weak var leftArrowImageView: UIImageView!
    
    let years: [WWDC] = [.WWDC2011, .WWDC2012, .WWDC2013, .WWDC2014, .WWDC2015, .WWDC2016]
    var allScholars: [Scholar] = []
    var currentScholars: [Scholar] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.scrollViewDidEndDecelerating(self.yearCollectionView)
        self.loadingView.startAnimating()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        ScholarsKit.sharedInstance.loadScholars({
            self.loadingView.stopAnimating()
            self.allScholars = DatabaseManager.sharedInstance.getAllScholars()
            
            self.getCurrentScholars()
            self.scrollCollectionViewToIndexPath(self.years.count - 1)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(ScholarDetailViewController) {
            if let indexPath = sender as? NSIndexPath {
                let destinationViewController = segue.destinationViewController as! ScholarDetailViewController
                destinationViewController.currentScholar = self.currentScholars[indexPath.item]
            }
        }
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
    
    // MARK: - Private functions
    
    private func getCurrentScholars(index: Int = 0) {
        let currentYear = self.years[index]
        
        self.currentScholars.removeAll()
        
        for scholar in self.allScholars {
            if scholar.batchWWDC.contains(currentYear) {
                self.currentScholars.append(scholar)
            }
        }
        
        self.scholarsCollectionView.reloadData()
    }
    
    private func scrollCollectionViewToIndexPath(index: Int) {
        self.yearCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        self.scrollViewDidEndDecelerating(self.yearCollectionView)
    }
}

// MARK: - UIScrollViewDelegate

extension ScholarsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //scholarsCollectionView page changed, update scholars list
        
        let currentIndex = Int(self.yearCollectionView.contentOffset.x / self.yearCollectionView.frame.size.width)
        
        self.getCurrentScholars(currentIndex)
        
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
            return self.currentScholars.count
        } else if collectionView == self.yearCollectionView {
            return self.years.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.scholarsCollectionView {
            let cell = self.scholarsCollectionView.dequeueReusableCellWithReuseIdentifier("scholarCollectionViewCell", forIndexPath: indexPath) as! ScholarCollectionViewCell
            let scholar = self.currentScholars[indexPath.item]
            
            cell.nameLabel.text = scholar.firstName
            cell.profileImageView.af_setImageWithURL(NSURL(string: scholar.profilePicURL)!, placeholderImage: UIImage(named: "placeholder"), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: false)
            
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(String(ScholarDetailViewController), sender: indexPath)
    }
}

extension ScholarsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let previewViewController = storyboard?.instantiateViewControllerWithIdentifier("scholarDetailViewController") as? ScholarDetailViewController else {
            return nil
        }
        
        guard let indexPath = self.scholarsCollectionView.indexPathForItemAtPoint(self.scholarsCollectionView.convertPoint(location, fromCoordinateSpace: self.view)) else {
            return nil
        }
        
        previewViewController.currentScholar = self.currentScholars[indexPath.item]
        previewViewController.preferredContentSize = CGSize.zero
        
        return previewViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.showViewController(viewControllerToCommit, sender: self)
    }
}