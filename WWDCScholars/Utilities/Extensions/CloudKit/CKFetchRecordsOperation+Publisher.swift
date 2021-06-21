//
//  CKFetchRecordsOperation+Publisher.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 22.03.21.
//

import CloudKit
import Combine

extension CKFetchRecordsOperation {
    /// Returns a publisher that wraps a `CKFetchRecordsOperation`.
    ///
    /// - Parameters:
    ///     - recordIDs: The ids of records to retrieve.
    ///     - desiredKeys: The fields of the records to fetch.
    ///     - database: The CloudKit database to perform the operation on.
    ///     - queue: Underlying queue to run the operation on.
    class func publisher(
        recordIDs: [CKRecord.ID],
        desiredKeys: [CKRecord.FieldKey]? = nil,
        in database: CKDatabase,
        on queue: DispatchQueue
    ) -> CKFetchRecordsOperation.Publisher {
        return CKFetchRecordsOperation.Publisher(
            recordIDs: recordIDs,
            desiredKeys: desiredKeys,
            in: database,
            on: queue
        )
    }

    class func publisher(
        recordID: CKRecord.ID,
        desiredKeys: [CKRecord.FieldKey]? = nil,
        in database: CKDatabase,
        on queue: DispatchQueue
    ) -> CKFetchRecordsOperation.Publisher {
        return CKFetchRecordsOperation.Publisher(
            recordIDs: [recordID],
            desiredKeys: desiredKeys,
            in: database,
            on: queue
        )
    }
}

extension CKFetchRecordsOperation {
    /// A publisher that wraps a `CKFetchRecordsOperation` and emits events as the operation completes.
    struct Publisher: Combine.Publisher {
        // MARK: Types

        /// The events emitted by the publisher.
        enum Action {
            /// Download progress was updated for a record.
            case recordProgress(Double, for: CKRecord.ID)

            /// Posted when all records were received from the server.
            case recordsFetched([CKRecord.ID: CKRecord])
        }

        // MARK: Properties

        /// The ids of records to retrieve.
        private let recordIDs: [CKRecord.ID]

        /// The fields of the records to fetch.
        private let desiredKeys: [CKRecord.FieldKey]?

        /// The CloudKit database to perform the operation on.
        private let database: CKDatabase

        /// Underlying queue to run the operation on.
        private let queue: DispatchQueue

        // MARK: Initialization

        /// Creates a new `CKFetchRecordsOperation.Publisher`.
        ///
        /// - Parameters:
        ///     - recordIDs: The ids of records to retrieve.
        ///     - desiredKeys: The fields of the records to fetch.
        ///     - database: The CloudKit database to perform the operation on.
        ///     - queue: Underlying queue to run the operation on.
        init(
            recordIDs: [CKRecord.ID],
            desiredKeys: [CKRecord.FieldKey]? = nil,
            in database: CKDatabase,
            on queue: DispatchQueue
        ) {
            self.recordIDs = recordIDs
            self.desiredKeys = desiredKeys
            self.database = database
            self.queue = queue
        }

        // MARK: Publisher Implementation

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(
                subscriber: subscriber,
                recordIDs: recordIDs,
                desiredKeys: desiredKeys,
                in: database,
                on: queue
            )
            subscriber.receive(subscription: subscription)
        }

        typealias Output = Action
        typealias Failure = Error
    }
}

// MARK: - Subscription

extension CKFetchRecordsOperation.Publisher {
    /// The subscription that wraps the actual operation execution and emits actions to its subscriber.
    final class Subscription<S: Subscriber> where S.Input == Output, S.Failure == Failure {
        // MARK: Properties

        /// The subscriber to notify of events.
        private var subscriber: S?

        /// The ids of records to retrieve.
        private let recordIDs: [CKRecord.ID]

        /// The fields of the records to fetch.
        private let desiredKeys: [CKRecord.FieldKey]?

        /// The CloudKit database to perform the operation on.
        private let database: CKDatabase

        /// Underlying queue to run the operation on.
        private let queue: DispatchQueue

        /// An operation queue to run all operations on.
        private let operationQueue: OperationQueue

        /// The operation when in flight.
        private var operation: CKFetchRecordsOperation?

        // MARK: Initialization

        init(
            subscriber: S,
            recordIDs: [CKRecord.ID],
            desiredKeys: [CKRecord.FieldKey]?,
            in database: CKDatabase,
            on queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.recordIDs = recordIDs
            self.desiredKeys = desiredKeys
            self.database = database
            self.queue = queue

            let operationQueue = OperationQueue()
            operationQueue.name = "\(queue.label): \(String(describing: type(of: self)))"
            operationQueue.underlyingQueue = queue
            operationQueue.qualityOfService = .userInitiated
            self.operationQueue = operationQueue
        }

        // MARK: Operation

        /// Configures the operation and sets up the callbacks to send events.
        private func configureOperation() {
            let operation = CKFetchRecordsOperation(recordIDs: recordIDs)

            operation.database = database
            operation.desiredKeys = desiredKeys
            operation.qualityOfService = .userInitiated

            operation.fetchRecordsCompletionBlock = { [weak self] records, error in
                if let error = error as? CKError {
                    self?.handleError(error)
                } else if let error = error {
                    self?.subscriber?.receive(completion: .failure(error))
                } else {
                    if let records = records {
                        _ = self?.subscriber?.receive(.recordsFetched(records))
                    }

                    self?.subscriber?.receive(completion: .finished)
                }
            }

            operation.perRecordProgressBlock = { recordID, progress in
                _ = self.subscriber?.receive(.recordProgress(progress, for: recordID))
            }

            queue.async {
                self.operation = operation
                self.operationQueue.addOperation(operation)
            }
        }

        /// Handle CloudKit errors.
        ///
        /// - Parameter error: The error to handle.
        private func handleError(_ error: CKError) {
            if let retryDelay = error.retryAfterSeconds {
                operationQueue.schedule(after: .init(Date() + retryDelay)) { [weak self] in
                    self?.configureOperation()
                }
            } else {
                subscriber?.receive(completion: .failure(error))
            }
        }
    }
}

// MARK: -

extension CKFetchRecordsOperation.Publisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
        operation?.cancel()
    }
}

extension CKFetchRecordsOperation.Publisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        guard subscriber != nil,
              operation == nil,
              demand > 0
        else { return }

        configureOperation()
    }
}
