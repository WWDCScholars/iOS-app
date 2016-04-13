//
//  ViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 27.02.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class ScholarsViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet weak var yearCarousel: iCarousel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var extendedNavigationContainer: UIView!
    
    let years = ["2014", "2015", "2016"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.yearCarousel.type = .Linear
        
        self.styleUI()
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
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.years.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let year = self.years[index]

        var backgroundView = UIView()
        let titleLabel = UILabel()
        let leftArrowImageView = UIImageView()
        let rightArrowImageView = UIImageView()
        
        //Create new view if no view is available for recycling
        if view == nil {
            backgroundView.frame = CGRect(x: 80, y: 0, width: self.view.frame.width - 160, height: 50)
            
            titleLabel.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.width, height: 50)
            titleLabel.text = year
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.textColor = UIColor.whiteColor()
            
            let leftOrigin = CGPoint(x: titleLabel.center.x - 50, y: titleLabel.center.y - 7.5)
            let leftSize = CGSize(width: 15, height: 15)
            leftArrowImageView.frame = CGRect(origin: leftOrigin, size: leftSize)
            leftArrowImageView.image = UIImage(named: "arrowLeft")
            leftArrowImageView.tintColor = UIColor.whiteColor()
            
            let rightOrigin = CGPoint(x: titleLabel.center.x + 35, y: titleLabel.center.y - 7.5)
            let rightSize = CGSize(width: 15, height: 15)
            rightArrowImageView.frame = CGRect(origin: rightOrigin, size: rightSize)
            rightArrowImageView.image = UIImage(named: "arrowRight")
            rightArrowImageView.tintColor = UIColor.whiteColor()
            
            backgroundView.backgroundColor = UIColor.scholarsPurpleColor()
            backgroundView.addSubview(titleLabel)
            
            if index != 0 {
                backgroundView.addSubview(leftArrowImageView)
            }
            
            if index != self.years.count - 1 {
                backgroundView.addSubview(rightArrowImageView)
            }
        } else {
            backgroundView = view!
        }
        
        return backgroundView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 1.1
        }
        
        return value
    }
}

// MARK: - UICollectionViewDataSource

extension ScholarsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}