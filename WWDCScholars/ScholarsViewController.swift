//
//  ScholarsViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ScholarsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var navigationBarExtensionView: NavigationBarExtensionView?
    @IBOutlet private weak var batchCollectionView: UICollectionView?
    @IBOutlet private weak var scholarCollectionView: UICollectionView?
    
    private let collectionViewContentController = CollectionViewContentController()
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.configureUI()
        self.configureContentController()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
        self.navigationBarExtensionView?.backgroundColor = .scholarsPurple
    }
    
    private func configureUI() {
        self.title = "Scholars"
        self.navigationController?.navigationBar.applyExtendedStyle()
    }
    
    // MARK: - Private Functions
    
    private func configureContentController() {
        self.collectionViewContentController.configure(collectionView: self.batchCollectionView)
        
        let batches: [ExampleBatch] = [BatchEarlier(), Batch2014(), Batch2015(), Batch2016(), Batch2017()]
        let batchesSectionContent = ScholarsViewControllerCellContentFactory.batchesSectionContent(from: batches)
        
        self.collectionViewContentController.add(sectionContent: batchesSectionContent)
        self.collectionViewContentController.reloadContent()
    }
}
