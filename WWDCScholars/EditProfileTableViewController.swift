//
//  EditProfileTableViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/04/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    @IBOutlet private weak var screenshotCollectionView: UICollectionView!
    
    let numberOfScreenshots = 4
    
    override func viewDidLoad() {
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.title = "Edit Profile"
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension EditProfileTableViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfScreenshots
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("screenshotUploadCollectionViewCell", forIndexPath: indexPath) as! ScreenshotUploadCollectionViewCell
        
        return cell
    }
}
