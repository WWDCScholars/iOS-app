//
//  CloudKitRepository.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import Combine

protocol CloudKitRepository {
    var database: CKDatabase { get }
    var queue: DispatchQueue { get }
}

extension CloudKitRepository {
    func query<Value>(_ query: CKQuery) -> AnyPublisher<[Value], Error> where Value: CKRecordConvertible {
        return CKQueryOperation.publisher(for: query, in: database, on: queue)
            .reduce([]) { values, action -> [Value] in
                if case let .recordFetched(record) = action,
                   let value = Value(record: record) {
                    return values + [value]
                }
                return values
            }
            .eraseToAnyPublisher()
    }

    func fetch<Value>(recordID: CKRecord.ID) -> AnyPublisher<Value, Error> where Value: CKRecordConvertible {
        return Deferred {
            return Future { promise in
                database.fetch(withRecordID: recordID) { record, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let record = record, let value = Value(record: record) {
                        promise(.success(value))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetch<Value>(recordIDs: [CKRecord.ID]) -> AnyPublisher<[CKRecord.ID: Value], Error> where Value: CKRecordConvertible {
        return CKFetchRecordsOperation.publisher(recordIDs: recordIDs, in: database, on: queue)
            .compactMap { action -> [CKRecord.ID: Value]? in
                guard case let .recordsFetched(records) = action else { return nil }
                return records.compactMapValues(Value.init(record:))
            }
            .eraseToAnyPublisher()
    }
}
