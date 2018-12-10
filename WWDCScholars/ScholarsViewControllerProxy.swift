//
//  ScholarsViewControllerProxy.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol ScholarsViewControllerProxyDelegate: class {
    var proxy: ScholarsViewControllerProxy? { get set }
    
    func didLoad(basicScholar: Scholar)
    func didLoadBatch()
}

internal final class ScholarsViewControllerProxy {
    
    // MARK: - Private Properties
    
    private weak var delegate: ScholarsViewControllerProxyDelegate?
    
    // MARK: - Lifecycle
    
    internal init(delegate: ScholarsViewControllerProxyDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Internal Functions
    
    internal func loadListScholars(batchInfo: WWDCYear) {
        CloudKitManager.shared.loadScholarsForList(in: batchInfo, with: .approved, recordFetched: self.basicScholarFetched) { (cursor, error) in
            guard error == nil else {
                // Do something
                return
            }
            DispatchQueue.main.async {
                self.delegate?.didLoadBatch()
            }
        }
    }
    
    private func basicScholarFetched(basicScholar: Scholar) {
        self.delegate?.didLoad(basicScholar: basicScholar)
    }
}
