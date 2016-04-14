//
//  ViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 27.02.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ScholarsViewController: UIViewController {
    @IBOutlet weak var yearCarousel: iCarousel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var extendedNavigationContainer: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mapView: UIView!
    
    let years: [WWDC] = [.WWDC2011, .WWDC2012, .WWDC2013, .WWDC2014, .WWDC2015, .WWDC2016]
    var scholars: [Scholar] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.yearCarousel.type = .Linear
        self.yearCarousel.bounces = false
        self.yearCarousel.scrollSpeed = 0.5
        self.yearCarousel.scrollToItemAtIndex(years.count - 1, animated: false)
        
        self.styleUI()
        
        ScholarsAPI.sharedInstance.loadScholars({
            self.scholars = DatabaseManager.sharedInstance.getAllScholars()
            self.collectionView.reloadData()
        })
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Scholars"
        
        self.extendedNavigationContainer.applyExtendedNavigationBarContainerStyle()
        self.applyExtendedNavigationBarStyle()
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

// MARK: - iCarouselDataSource, iCarouselDelegate

extension ScholarsViewController: iCarouselDataSource, iCarouselDelegate {
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.years.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let year = self.years[index]
        
        let backgroundView = UIView()
        let titleLabel = UILabel()
        let leftArrowImageView = UIImageView()
        let rightArrowImageView = UIImageView()
        
        backgroundView.frame = CGRect(x: 80, y: 0, width: self.view.frame.width - 160, height: 50)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.width, height: 50)
        titleLabel.text = year.rawValue
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        
        let leftOrigin = CGPoint(x: titleLabel.center.x - 50, y: titleLabel.center.y - 7.5)
        let leftSize = CGSize(width: 15, height: 15)
        leftArrowImageView.frame = CGRect(origin: leftOrigin, size: leftSize)
        leftArrowImageView.image = UIImage(named: "arrowLeft")
        leftArrowImageView.tintColor = UIColor.transparentWhiteColor()
        
        let rightOrigin = CGPoint(x: titleLabel.center.x + 35, y: titleLabel.center.y - 7.5)
        let rightSize = CGSize(width: 15, height: 15)
        rightArrowImageView.frame = CGRect(origin: rightOrigin, size: rightSize)
        rightArrowImageView.image = UIImage(named: "arrowRight")
        rightArrowImageView.tintColor = UIColor.transparentWhiteColor()
        
        backgroundView.backgroundColor = UIColor.scholarsPurpleColor()
        backgroundView.addSubview(titleLabel)
        
        if index != 0 {
            backgroundView.addSubview(leftArrowImageView)
        }
        
        if index != self.years.count - 1 {
            backgroundView.addSubview(rightArrowImageView)
        }
        
        return backgroundView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .Spacing {
            return value * 1.1
        }
        
        return value
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.scholars.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("scholarCollectionViewCell", forIndexPath: indexPath) as! ScholarCollectionViewCell
        let scholar = self.scholars[indexPath.item]
        
        cell.nameLabel.text = scholar.fullName
        cell.profileImageView.image = UIImage(named: "Matthijs Logemann")
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ScholarsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width / 3.0) - 8.0, height: 120.0)
    }    
}