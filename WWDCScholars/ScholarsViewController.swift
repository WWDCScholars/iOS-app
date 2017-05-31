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
    private var batches: [BatchInfo] = [BatchInfo2013(), BatchInfo2014(), BatchInfo2015(), BatchInfo2016(), BatchInfo2017(), BatchInfoSaved()]
    
    // MARK: - File Private Properties
    
    fileprivate var scholars = [BasicScholar]()
    
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
    
    fileprivate func updateContainerViewsContent() {
        self.scholarsListViewController?.scholars = self.scholars
        self.scholarsListViewController?.configureScholarContentController()
        self.scholarsMapViewController?.scholars = self.scholars
        self.scholarsMapViewController?.configureMapContent()
    }
    
    // MARK: - Private Functions
    
    private func configureBatchContentController() {
        self.batchCollectionViewContentController.configure(collectionView: self.batchCollectionView)
        
        let batchSectionContent = ScholarsViewControllerCellContentFactory.batchSectionContent(from: self.batches, delegate: self)
        
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
    
    internal func didLoad(basicScholar: BasicScholar) {
        self.scholars.append(basicScholar)
    }
    
    internal func didLoadBatch() {
        self.updateContainerViewsContent()
    }
}

extension ScholarsViewController: BatchCollectionViewCellContentDelegate {
    
    // MARK: - Internal Functions
    
    internal func update(for batchInfo: BatchInfo) {
        self.proxy?.loadListScholars(batchInfo: batchInfo)
    }
}
