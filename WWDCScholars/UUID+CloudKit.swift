//
//  UUID+CloudKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 06/06/2019.
//  Copyright © 2019 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

extension UUID {
    func asRecordId() -> CKRecord.ID {
        return CKRecord.ID.init(recordName: self.uuidString)
    }
}
