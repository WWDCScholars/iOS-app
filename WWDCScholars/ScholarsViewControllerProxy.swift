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
    
    internal func loadBasicScholars(for batchInfo: BatchInfo) {
        CloudKitManager.shared.loadScholarsForList(in: batchInfo, with: .approved, recordFetched: self.basicScholarLoaded) { (cursor, error) in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.didLoadBatch()
            }
        }
    }
    
    internal func basicScholarsForSelectedBatchInfo() -> [BasicScholar] {
        return BatchManager.shared.basicScholarsForSelectedBatchInfo()
    }
    
    internal func set(selectedBatchInfo: BatchInfo) {
        BatchManager.shared.set(selectedBatchInfo: selectedBatchInfo)
    }
    
    internal func add(basicScholar: BasicScholar, for batchInfo: BatchInfo) {
        BatchManager.shared.add(basicScholar: basicScholar, to: batchInfo)
    }
    
    // MARK: - Private Functions
    
    private func basicScholarLoaded(basicScholar: BasicScholar, batchInfo: BatchInfo) {
        self.add(basicScholar: basicScholar, for: batchInfo)
    }
}
