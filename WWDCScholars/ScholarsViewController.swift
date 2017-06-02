//
//  ScholarsViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
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
    
    private var scholarsMapViewController: ScholarsMapViewController?
    private var scholarsListViewController: ScholarsListViewController?
    private var containerViewSwitchHelper: ContainerViewSwitchHelper?
    
    // MARK: - Internal Properties
    
    internal var proxy: ScholarsViewControllerProxy?
    
    // MARK: - Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        let scholarsListContainerViewContent = ContainerViewElements(view: self.scholarsListContainerView, viewController: self.scholarsListViewController)
        let scholarsMapContainerViewContent = ContainerViewElements(view: self.scholarsMapContainerView, viewController: self.scholarsMapViewController)
        self.containerViewSwitchHelper = ContainerViewSwitchHelper(activeContainerViewElements: scholarsListContainerViewContent, inactiveContainerViewElements: scholarsMapContainerViewContent)
        
        self.proxy = ScholarsViewControllerProxy(delegate: self)
        
        self.styleUI()
        self.configureUI()
        self.configureBatchContentController()
        self.selectDefaultBatch()
        self.scrollToSelectedBatch()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ScholarsListViewController" {
            let scholarsListViewController = segue.destination as? ScholarsListViewController
            self.scholarsListViewController = scholarsListViewController
            return
        }
        
        if segue.identifier == "ScholarsMapViewController" {
            let scholarsMapViewController = segue.destination as? ScholarsMapViewController
            self.scholarsMapViewController = scholarsMapViewController
            return
        }
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.view.applyBackgroundStyle()
        self.navigationController?.navigationBar.applyExtendedStyle()
        self.navigationBarExtensionView?.backgroundColor = .scholarsPurple
    }
    
    private func configureUI() {
        self.title = "Scholars"
    }
    
    // MARK: - Internal Functions
    
    internal func selectSavedBatch() {
        self.batchCollectionViewContentController.selectSavedBatch()
    }
    
    internal func scrollToSelectedBatch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.batchCollectionViewContentController.scrollToSelectedBatch()
        })
    }
    
    // MARK: - File Private Functions
    
    fileprivate func updateContainerViewsContent(with basicScholars: [BasicScholar]) {
        self.scholarsListViewController?.scholars = basicScholars
        self.scholarsListViewController?.configureScholarContentController()
        self.scholarsMapViewController?.scholars = basicScholars
        self.scholarsMapViewController?.configureMapContent()
    }
    
    // MARK: - Private Functions
    
    private func configureBatchContentController() {
        self.batchCollectionViewContentController.configure(collectionView: self.batchCollectionView)
        
        let batchInfos = BatchManager.shared.batchesInfos
        let batchSectionContent = ScholarsViewControllerCellContentFactory.batchSectionContent(from: batchInfos, delegate: self)
        
        self.batchCollectionViewContentController.add(sectionContent: batchSectionContent)
        self.batchCollectionViewContentController.reloadContent()
    }
    
    private func selectDefaultBatch() {
        self.batchCollectionViewContentController.selectDefaultBatch()
    }
    
    // MARK: - Actions
    
    @IBAction internal func switchViewButtonTapped() {
        self.containerViewSwitchHelper?.switchViews()
        
        let rightBarButtonItemImage = (self.containerViewSwitchHelper?.inactiveContainerViewElements?.view as? ScholarsSwitchableContainerView)?.navigationBarItemImage
        self.navigationItem.rightBarButtonItem?.image = rightBarButtonItemImage
    }
}

extension ScholarsViewController: ScholarsViewControllerProxyDelegate {
    
    // MARK: - Internal Functions
    
    internal func didLoad(basicScholar: BasicScholar, for batchInfo: BatchInfo) {
        BatchManager.shared.add(basicScholar: basicScholar, to: batchInfo)
    }
    
    internal func didLoadBasicScholars(for batchInfo: BatchInfo) {
        guard batchInfo === BatchManager.shared.selectedBatchInfo else {
            return
        }
        
        let basicScholars = BatchManager.shared.basicScholarsForSelectedBatchInfo()
        self.updateContainerViewsContent(with: basicScholars)
    }
}

extension ScholarsViewController: BatchCollectionViewCellContentDelegate {
    
    // MARK: - Internal Functions
    
    internal func update(for batchInfo: BatchInfo) {
        // Cancel any current loading batches?
        
        BatchManager.shared.set(selectedBatchInfo: batchInfo)
        
        let basicScholars = BatchManager.shared.basicScholarsForSelectedBatchInfo()
        guard !basicScholars.isEmpty else {
            self.proxy?.loadBasicScholars(for: batchInfo)
            return
        }
        
        self.updateContainerViewsContent(with: basicScholars)
    }
}
