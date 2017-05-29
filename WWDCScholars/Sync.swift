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
    
    private let semaphore: DispatchSemaphore
    
    public init() {
        semaphore = DispatchSemaphore.init(value: 0)
    }
    
    public func complete() {
        semaphore.signal()
    }
    
    public func wait(seconds timeout: TimeInterval = 0) {
        let start = NSDate()
        while semaphore.wait(timeout: DispatchTime.now()) != .success {
            let intervalDate = Date(timeIntervalSinceNow: 0.01) // 10 msec
            RunLoop.current.run(until: intervalDate)
            //            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: intervalDate)
            if timeout > 0 && Date().timeIntervalSince(start as Date) > timeout {
                break
            }
        }
    }
    
}
