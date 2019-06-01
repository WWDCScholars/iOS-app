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
    @IBOutlet private weak var loadingScholarsView: UIView!
    @IBOutlet private weak var loadingScholarsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scholarsMapContainerView: ScholarsMapContainerView?
    @IBOutlet private weak var scholarsListContainerView: ScholarsListContainerView?

    private let batchCollectionViewContentController = CollectionViewContentController()

    private var scholarsMapViewController: ScholarsMapViewController?
    private var scholarsListViewController: ScholarsListViewController?
    private var containerViewSwitchHelper: ContainerViewSwitchHelper?
    private var batches: [WWDCYear] = [.wwdc2013, .wwdc2014, .wwdc2015, .wwdc2016, .wwdc2017, .wwdc2018, .wwdc2019]

    // MARK: - File Private Properties

    fileprivate var scholars = [Scholar]()

    // MARK: - Internal Properties

    internal var proxy: ScholarsViewControllerProxy?

    // MARK: - Lifecycle

    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingScholarsActivityIndicator.startAnimating()
        loadingScholarsView.isHidden = false

        let scholarsListContainerViewContent = ContainerViewElements(view: self.scholarsListContainerView, viewController: self.scholarsListViewController)
        let scholarsMapContainerViewContent = ContainerViewElements(view: self.scholarsMapContainerView, viewController: self.scholarsMapViewController)
        self.containerViewSwitchHelper = ContainerViewSwitchHelper(activeContainerViewElements: scholarsListContainerViewContent, inactiveContainerViewElements: scholarsMapContainerViewContent)

        self.proxy = ScholarsViewControllerProxy(delegate: self)

        self.styleUI()
        self.configureUI()
        self.configureWWDCYearInfoContentController()
        self.selectDefaultWWDCYearInfo()
        self.scrollToSelectedWWDCYearInfo()
        self.checkForIntroSeenYet()
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

        if segue.identifier == "ProfileViewController" {
            let scholarProfileViewController = segue.destination as? ProfileViewController
//            scholarProfileViewController?.scholarId = sender as? CKRecordID
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

    private func showIntro() {
        let storyboard = UIStoryboard.init(name: "Intro", bundle: nil)
        let intro = storyboard.instantiateInitialViewController()!
        self.present(intro, animated: true, completion: nil)
    }

    // MARK: - Internal Functions

    internal func selectSavedWWDCYearInfo() {
        self.batchCollectionViewContentController.selectSavedWWDCYearInfo()
    }

    internal func scrollToSelectedWWDCYearInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.batchCollectionViewContentController.scrollToSelectedWWDCYearInfo()
        })
    }

    internal func checkForIntroSeenYet(){
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "userHasSeen2019Intro") == true{

        }else{
            userDefaults.set(true, forKey: "userHasSeen2019Intro")
            showIntro()
        }
    }

    // MARK: - File Private Functions

    fileprivate func updateContainerViewsContent() {
        self.scholarsListViewController?.scholars = self.scholars
        self.scholarsListViewController?.configureScholarContentController()
        self.scholarsMapViewController?.scholars = self.scholars
        self.scholarsMapViewController?.configureMapContent()
        
        loadingScholarsActivityIndicator.stopAnimating()
        loadingScholarsView.isHidden = true
    }

    // MARK: - Private Functions

    private func configureWWDCYearInfoContentController() {
        self.batchCollectionViewContentController.configure(collectionView: self.batchCollectionView)

        let batchSectionContent = ScholarsViewControllerCellContentFactory.batchSectionContent(from: self.batches, delegate: self)

        self.batchCollectionViewContentController.add(sectionContent: batchSectionContent)
        self.batchCollectionViewContentController.reloadContent()
    }

    private func selectDefaultWWDCYearInfo() {
        self.batchCollectionViewContentController.selectDefaultWWDCYearInfo()
    }

    // MARK: - Actions

    @IBAction internal func switchViewButtonTapped() {
        self.containerViewSwitchHelper?.switchViews()

        let rightBarButtonItemImage = (self.containerViewSwitchHelper?.inactiveContainerViewElements?.view as? ScholarsSwitchableContainerView)?.navigationBarItemImage
        self.navigationItem.rightBarButtonItem?.image = rightBarButtonItemImage
    }
}

extension ScholarsViewController: ScholarsViewControllerProxyDelegate {
    func didLoadWWDCYearInfo() {
        // TODO: O
        print("didLoadWWDCYearInfo")

    }
    
    // MARK: - Internal Functions
    internal func didLoad(basicScholar: Scholar) {
		scholars.append(basicScholar)
        print("didLoad basicScholar")
    }

    internal func didLoad(scholars: [Scholar]) {
        self.scholars = scholars.sorted(by: { $0.givenName! < $1.givenName! })
        
        print("didLoad scholars")
    }

    internal func didLoadBatch() {
        self.updateContainerViewsContent()
        print("didLoadBatch")
    }
}

extension ScholarsViewController: WWDCYearInfoCollectionViewCellContentDelegate {

    // MARK: - Internal Functions

    internal func update(for batchInfo: WWDCYear) {
        print("update")
        
		self.scholars = []
        self.proxy?.loadListScholars(batchInfo: batchInfo)
    }
}
