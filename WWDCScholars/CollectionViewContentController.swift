//
//  CollectionViewContentController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class CollectionViewContentController: NSObject, ContentController {

    // MARK: - internal Properties

    internal var collectionView: UICollectionView?
    internal var sectionContent = [SectionContent]()

    // MARK: - internal Functions

    internal func configure(collectionView: UICollectionView?) {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.collectionView = collectionView
    }

    internal func reloadContent() {
        self.collectionView?.reloadData()
    }
}

extension CollectionViewContentController: UICollectionViewDelegate {

    // MARK: - internal Functions

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = self.cellContent(for: indexPath)
        (content as? Selectable)?.performAction(on: self.collectionView, with: self.sectionContent, at: indexPath)

        self.collectionView?.deselectItem(at: indexPath, animated: true)
    }
}

extension CollectionViewContentController: UICollectionViewDataSource {

    // MARK: - internal Functions

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems(in: section)
    }

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = self.reuseIdentifier(for: indexPath)
        let defaultCell = UICollectionViewCell()
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) ?? defaultCell
        let cellContent = self.cellContent(for: indexPath)
        (cell as? Cell)?.configure(with: cellContent)
        return cell
    }
}
