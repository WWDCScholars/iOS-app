//
//  ScholarsListViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class ScholarsListViewController: UIViewController, ContainerViewController {

    // MARK: - Private Properties
    
    @IBOutlet private weak var scholarCollectionView: UICollectionView?
    
    private let scholarCollectionViewContentController = CollectionViewContentController()
    
    // MARK: - Internal Properties
    
    internal var scholars = [Scholar]()
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
    }
    
    // MARK: - Internal Functions
    
    internal func configureScholarContentController() {
        self.scholarCollectionViewContentController.configure(collectionView: self.scholarCollectionView)
        
        let batchesSectionContent = ScholarsListViewControllerCellContentFactory.scholarSectionContent(from: self.scholars, delegate: self)
        self.scholarCollectionViewContentController.set(sectionContent: batchesSectionContent)
        
        self.scholarCollectionViewContentController.reloadContent()
    }
}

extension ScholarsListViewController: ScholarCollectionViewCellContentDelegate {
    
    // MARK: - Internal Functions
    
    internal func presentProfile(for scholar: Scholar) {
        self.presentProfileViewController(scholarId: scholar.id!)
    }
}
