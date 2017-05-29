//
//  ScholarListViewControllerProxy.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol ScholarListViewControllerProxyDelegate: class {
    var proxy: ScholarListViewControllerProxy? { get set }
    
    func didLoadListScholar(listScholar: ListScholar)
    func didFinishLoadingListScholars()
    func failedToLoadListScholars()
}

internal final class ScholarListViewControllerProxy {
    
    // MARK: - Private Properties
    
    private weak var delegate: ScholarListViewControllerProxyDelegate?
    
    // MARK: - Lifecycle
    
    internal init(delegate: ScholarListViewControllerProxyDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Internal Functions
    
    internal func loadListScholars(batch: String) {
        CloudKitManager.shared.loadScholarsForList(in: batch, with: .approved, recordFetched: self.listScholarFetched, completion: nil)
    }
    
    private func listScholarFetched(listScholar: ListScholar) {
        self.delegate?.didLoadListScholar(listScholar: listScholar)
    }
}
