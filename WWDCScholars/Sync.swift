//
//  Sync.swift
//  Sync
//
//  Created by Eneko Alonso on 2/25/16.
//  Copyright © 2016 Eneko Alonso. All rights reserved.
//

import Dispatch
import Foundation

public struct SyncBlock {
    
    // MARK: - Private Properties
    
    private let semaphore: DispatchSemaphore
    
    // MARK: - Lifecycle
    
    internal init() {
        semaphore = DispatchSemaphore.init(value: 0)
    }
    
    // MARK: - Internal Functions
    
    internal func complete() {
        semaphore.signal()
    }
    
    internal func wait(seconds timeout: TimeInterval = 0.0) {
        let start = Date()
        while semaphore.wait(timeout: .now()) != .success {
            let intervalDate = Date(timeIntervalSinceNow: 0.01) // 10 msec
            RunLoop.current.run(until: intervalDate)
            if timeout > 0.0 && Date().timeIntervalSince(start as Date) > timeout {
                break
            }
        }
    }
}
