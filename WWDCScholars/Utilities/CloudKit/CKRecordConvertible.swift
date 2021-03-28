//
//  CKRecordConvertible.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit

protocol CKRecordConvertible {
    static var recordType: String { get }
    init?(record: CKRecord)
}
