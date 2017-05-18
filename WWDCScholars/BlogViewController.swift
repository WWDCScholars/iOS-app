//
//  BlogViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BlogViewController: UIViewController {
    
    // MARK: - File Private Properties
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView?
    
    fileprivate let cellHeight: CGFloat = 184.0
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
    }
    
    private func configureUI() {
        self.title = "Blog"
    }
}

extension BlogViewController: UICollectionViewDataSource {
    
    // MARK: - Internal Functions
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "blogPostCollectionViewCell", for: indexPath)
        return cell!
    }
}

extension BlogViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Internal Functions
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize()
    }
    
    // MARK: - Private Functions
    
    private func cellSize() -> CGSize {
        let viewSize = self.view.frame.size
        let edgeInset: CGFloat = 8.0
        let cellWidth = viewSize.width - (edgeInset * 2.0)
        let cellHeight = self.cellHeight
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }
}
