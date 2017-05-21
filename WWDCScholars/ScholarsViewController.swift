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
    @IBOutlet private weak var scholarsMapContainerView: ScholarsMapContainerView?
    @IBOutlet private weak var scholarsListContainerView: ScholarsListContainerView?
    
    private let batchCollectionViewContentController = CollectionViewContentController()
    private let scholars: [ExampleScholar] = [ScholarOne(), ScholarTwo(), ScholarThree()]
    
    private var scholarsMapViewController: ScholarsMapViewController?
    private var scholarsListViewController: ScholarsListViewController?
    private var containerViewTransitionHelper: ContainerViewTransitionHelper?
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerViewTransitionHelper = ContainerViewTransitionHelper(activeView: self.scholarsListContainerView, inactiveView: self.scholarsMapContainerView)
        
        self.styleUI()
        self.configureUI()
        self.configureBatchContentController()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ScholarsListViewController" {
            let scholarsListViewController = segue.destination as? ScholarsListViewController
            scholarsListViewController?.scholars = self.scholars
            self.scholarsListViewController = scholarsListViewController
            return
        }
        
        if segue.identifier == "ScholarsMapViewController" {
            let scholarsMapViewController = segue.destination as? ScholarsMapViewController
            scholarsMapViewController?.scholars = self.scholars
            self.scholarsMapViewController = scholarsMapViewController
            return
        }
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
    
    private func configureBatchContentController() {
        self.batchCollectionViewContentController.configure(collectionView: self.batchCollectionView)
        
        let batches: [ExampleBatch] = [BatchEarlier(), Batch2014(), Batch2015(), Batch2016(), Batch2017()]
        let batchesSectionContent = ScholarsViewControllerCellContentFactory.batchesSectionContent(from: batches)
        
        self.batchCollectionViewContentController.add(sectionContent: batchesSectionContent)
        self.batchCollectionViewContentController.reloadContent()
    }
    
    // MARK: - Actions
    
    @IBAction internal func switchViewButtonTapped() {
        self.containerViewTransitionHelper?.switchViews()
        
        let rightBarButtonItemImage = (self.containerViewTransitionHelper?.inactiveView as? TransitionalContainerView)?.navigationBarItemImage
        self.navigationItem.rightBarButtonItem?.image = rightBarButtonItemImage
    }
}
