//
//  CollectionViewContentController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
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
    
    internal func select(cellContent: CellContent) {
        guard let indexPath = self.indexPath(of: cellContent) else {
            return
        }
        
        self.performSelection(on: cellContent, at: indexPath)
    }
    
    // MARK: - File Private Functions
    
    fileprivate func performSelection(on cellContent: CellContent, at indexPath: IndexPath) {
        (cellContent as? SelectableCellContent)?.select(on: self.collectionView, with: self.sectionContent, at: indexPath)
        (cellContent as? ActionableCellContent)?.action()
    }
}

extension CollectionViewContentController: UICollectionViewDelegate {

    // MARK: - internal Functions

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellContent = self.cellContentFor(indexPath: indexPath)
        self.performSelection(on: cellContent, at: indexPath)
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
        let cellContent = self.cellContentFor(indexPath: indexPath)
        (cell as? Cell)?.configure(with: cellContent)
        return cell
    }
}

extension CollectionViewContentController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Internal Functions
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionContent = self.sizeableCollectionViewSectionContent(for: indexPath.section) else {
            return .zero
        }
        
        guard let cellContent = self.sizeableCollectionViewCellContent(for: indexPath) else {
            return .zero
        }
        
        return cellContent.size(within: collectionView, sizingModifiers: sectionContent.sizingModifiers)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sizeableCollectionViewSectionContent(for: section)?.sizingModifiers.edgeInsets ?? .zero
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sizeableCollectionViewSectionContent(for: section)?.sizingModifiers.minimumLineSpacing ?? 0.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.sizeableCollectionViewSectionContent(for: section)?.sizingModifiers.minimumInteritemSpacing ?? 0.0
    }
    
    // MARK: - Private Functions
    
    private func sizeableCollectionViewCellContent(for indexPath: IndexPath) -> SizeableCollectionViewCellContent? {
        return self.cellContentFor(indexPath: indexPath) as? SizeableCollectionViewCellContent
    }
    
    private func sizeableCollectionViewSectionContent(for section: Int) -> SizeableCollectionViewSectionContent? {
        return self.sectionContent[section] as? SizeableCollectionViewSectionContent
    }
}
