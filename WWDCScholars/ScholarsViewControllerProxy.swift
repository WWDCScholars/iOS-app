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
    
    func didLoad(basicScholar: BasicScholar, for batchInfo: BatchInfo)
    func didLoadBasicScholars(for batchInfo: BatchInfo)
}

internal final class ScholarsViewControllerProxy {
    
    // MARK: - Private Properties
    
    private weak var delegate: ScholarsViewControllerProxyDelegate?
    
    // MARK: - Lifecycle
    
    internal init(delegate: ScholarsViewControllerProxyDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Internal Functions
    
    internal func loadBasicScholars(for batchInfo: BatchInfo) {
        CloudKitManager.shared.loadScholarsForList(in: batchInfo, with: .approved, recordFetched: self.basicScholarFetched) { (cursor, error) in
            guard error == nil else {
                // Do something
                return
            }
            DispatchQueue.main.async {
                self.delegate?.didLoadBasicScholars(for: batchInfo)
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func basicScholarFetched(basicScholar: BasicScholar, batchInfo: BatchInfo) {
        self.delegate?.didLoad(basicScholar: basicScholar, for: batchInfo)
    }
}
