//
//  CKDataController.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 18/12/2018.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

class CKDataController: ScholarDataController {
    typealias Iterator = CKDataIterator
    
    func scholars(for year: WWDCYear, with status: Scholar.Status?) -> [Scholar] {
        return []
    }
    
    func scholar(for id: UUID) -> Scholar? {
        return nil
    }
    
    func scholarData(for year: WWDCYear, scholar: Scholar) -> Batch? {
        return nil
    }
    
    func countScholars(for year: WWDCYear?) -> Int {
        return 0
    }
    
    func add(_ scholar: Scholar) {
        fatalError("add(_ scholar:) has not been implemented")
    }
    
    func remove(_ scholar: Scholar) {
        fatalError("remove(_ scholar:) has not been implemented")
    }
    
    func update(_ scholar: Scholar) {
        fatalError("update(_ scholar:) has not been implemented")
    }
    
    func iterator(for year: WWDCYear) -> Iterator {
        return CKDataIterator.init(year)
    }
    
}

internal struct CKDataIterator: ScholarIterator {
    let wwdcYear: WWDCYear

    let cursor: CKQueryOperation.Cursor

    init(_ wwdcYear: WWDCYear) {
        self.wwdcYear = wwdcYear
    }
    
    func next() -> Scholar? {
     return cursor.
    }
}
