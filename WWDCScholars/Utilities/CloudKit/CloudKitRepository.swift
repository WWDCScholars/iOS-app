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
    func queryAll<Value>(_ query: CKQuery, desiredKeys: [CKRecord.FieldKey]? = nil) -> AnyPublisher<[Value], Error> where Value: CKRecordConvertible {
        return CKQueryOperation.publisher(for: query, desiredKeys: desiredKeys, in: database, on: queue)
            .compactMap(Value.init(record:))
            .collect()
            .eraseToAnyPublisher()
    }

    func query<Value>(_ query: CKQuery) -> AnyPublisher<Value, Error> where Value: CKRecordConvertible {
        return CKQueryOperation.publisher(for: query, in: database, on: queue)
            .compactMap(Value.init(record:))
            .eraseToAnyPublisher()
    }

    func fetch(recordID: CKRecord.ID, desiredKeys: [CKRecord.FieldKey]? = nil) -> AnyPublisher<CKRecord, Error> {
        return CKFetchRecordsOperation.publisher(recordID: recordID, desiredKeys: desiredKeys, in: database, on: queue)
            .compactMap { action -> CKRecord? in
                guard case let .recordsFetched(records) = action else { return nil }
                return records[recordID]
            }
            .eraseToAnyPublisher()
    }

    func fetch<Value>(recordID: CKRecord.ID, desiredKeys: [CKRecord.FieldKey]? = nil) -> AnyPublisher<Value, Error> where Value: CKRecordConvertible {
        return CKFetchRecordsOperation.publisher(recordID: recordID, desiredKeys: desiredKeys, in: database, on: queue)
            .compactMap { action -> CKRecord? in
                guard case let .recordsFetched(records) = action else { return nil }
                return records[recordID]
            }
            .compactMap(Value.init(record:))
            .eraseToAnyPublisher()
    }

    func fetch<Value>(recordIDs: [CKRecord.ID], desiredKeys: [CKRecord.FieldKey]? = nil) -> AnyPublisher<[CKRecord.ID: Value], Error> where Value: CKRecordConvertible {
        return CKFetchRecordsOperation.publisher(recordIDs: recordIDs, desiredKeys: desiredKeys, in: database, on: queue)
            .compactMap { action -> [CKRecord.ID: Value]? in
                guard case let .recordsFetched(records) = action else { return nil }
                return records.compactMapValues(Value.init(record:))
            }
            .eraseToAnyPublisher()
    }
}
