//
//  FAQItem.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 23.06.21.
//

import CloudKit

struct FAQItem {
    let recordName: String

    let index: Int
    let question: String
    let comment: String?
    let answer: String
}

extension FAQItem: Identifiable {
    var id: String { recordName }
}

extension FAQItem: Equatable {}

extension FAQItem: CKRecordConvertible {
    init?(record: CKRecord) {
        guard let index = record["index"] as? Int,
              let question = record["question_en"] as? String,
              let answer = record["answer_en"] as? String
        else { return nil }

        recordName = record.recordID.recordName

        self.index = index
        self.question = question
        comment = record["comment_en"] as? String
        self.answer = answer
    }
}

// MARK: - Partial Fetching

extension FAQItem {
    enum DesiredKeys {
        static func `default`(for languageCode: String) -> [CKRecord.FieldKey] {
            ["index", "question_en", "comment_en", "answer_en"]
        }
    }
}
