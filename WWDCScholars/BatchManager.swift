//
//  BatchManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 01/06/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class BatchManager {
    
    // MARK: - Internal Properties
    
    internal static let shared = BatchManager()
    internal let batchesInfos: [BatchInfo] = [BatchInfo2013(), BatchInfo2014(), BatchInfo2015(), BatchInfo2016(), BatchInfo2017(), BatchInfoSaved()]
    
    internal var selectedBatchInfo: BatchInfo?
    
    // MARK: - Lifecycle
    
    private init() {
        self.selectedBatchInfo = self.batchesInfos.filter({ $0.isDefault }).first
    }
    
    // MARK: - Internal Functions
    
    internal func add(basicScholar: BasicScholar, to batchInfo: BatchInfo) {
        guard let batchInfoIndex = BatchManager.shared.batchesInfos.index(where: { $0 === batchInfo }) else {
            return
        }
        
        self.batchesInfos[batchInfoIndex].basicScholars.append(basicScholar)
    }
    
    internal func set(selectedBatchInfo: BatchInfo) {
        self.selectedBatchInfo = selectedBatchInfo
    }
    
    internal func basicScholarsForSelectedBatchInfo() -> [BasicScholar] {
        return self.selectedBatchInfo?.basicScholars ?? []
    }
}
