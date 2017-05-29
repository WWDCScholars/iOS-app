//
//  CloudKitInitializable.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitItem {
    var id: CKRecordID { get }
}

protocol CloudKitInitializable: CloudKitItem {
    init(record: CKRecord)
}
