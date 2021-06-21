//
//  CKQueryOperation+Publisher.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import Combine

extension CKQueryOperation {
    /// Returns a publisher that wraps a `CKQueryOperation`.
    ///
    /// - Parameters:
    ///     - query: The query to perform.
    ///     - desiredKeys: The fields of the records to fetch.
    ///     - resultsLimit: The maximum number of records to return at one time.
    ///     - database: The CloudKit database to perform the operation on.
    ///     - queue: Underlying queue to run the operation on.
    class func publisher(
        for query: CKQuery,
        desiredKeys: [CKRecord.FieldKey]? = nil,
        resultsLimit: Int? = nil,
        in database: CKDatabase,
        on queue: DispatchQueue
    ) -> CKQueryOperation.Publisher {
        return CKQueryOperation.Publisher(
            for: query,
            desiredKeys: desiredKeys,
            resultsLimit: resultsLimit,
            in: database,
            on: queue
        )
    }
}

extension CKQueryOperation {
    /// A publisher that wraps a `CKQueryOperation` and emits records as the operation completes.
    struct Publisher: Combine.Publisher {
        // MARK: Properties

        /// The query to perform.
        private let query: CKQuery

        /// The fields of the records to fetch.
        private let desiredKeys: [CKRecord.FieldKey]?

        /// The maximum number of records to return at one time.
        private let resultsLimit: Int?

        /// The CloudKit database to perform the operation on.
        private let database: CKDatabase

        /// Underlying queue to run the operation on.
        private let queue: DispatchQueue

        // MARK: Initialization

        /// Creates a new `CKQueryOperation.Publisher`.
        ///
        /// - Parameters:
        ///     - query: The query to perform.
        ///     - desiredKeys: The fields of the records to fetch.
        ///     - resultsLimit: The maximum number of records to return at one time.
        ///     - database: The CloudKit database to perform the operation on.
        ///     - queue: Underlying queue to run the operation on.
        init(
            for query: CKQuery,
            desiredKeys: [CKRecord.FieldKey]? = nil,
            resultsLimit: Int? = nil,
            in database: CKDatabase,
            on queue: DispatchQueue
        ) {
            self.query = query
            self.desiredKeys = desiredKeys
            self.resultsLimit = resultsLimit
            self.database = database
            self.queue = queue
        }

        // MARK: Publisher Implementation

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(
                subscriber: subscriber,
                for: query,
                desiredKeys: desiredKeys,
                resultsLimit: resultsLimit,
                in: database,
                on: queue
            )
            subscriber.receive(subscription: subscription)
        }

        typealias Output = CKRecord
        typealias Failure = Error
    }
}

// MARK: - Subscription

extension CKQueryOperation.Publisher {
    /// The subscription that wraps the actual operation execution and emits actions to its subscriber.
    final class Subscription<S: Subscriber> where S.Input == Output, S.Failure == Failure {
        // MARK: Properties

        /// The subscriber to notify of events.
        private var subscriber: S?

        /// The query to perform
        private let query: CKQuery

        /// The fields of the records to fetch.
        private let desiredKeys: [CKRecord.FieldKey]?

        /// The maximum number of records to return at one time.
        private let resultsLimit: Int?

        /// The CloudKit database to perform the operation on.
        private let database: CKDatabase

        /// Underlying queue to run the operation.
        private let queue: DispatchQueue

        /// An operation queue to run all operations on.
        private let operationQueue: OperationQueue

        // MARK: Initialization

        init(
            subscriber: S,
            for query: CKQuery,
            desiredKeys: [CKRecord.FieldKey]?,
            resultsLimit: Int?,
            in database: CKDatabase,
            on queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.query = query
            self.desiredKeys = desiredKeys
            self.resultsLimit = resultsLimit
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
        private func configureOperation(_ operation: CKQueryOperation) {
            operation.database = database
            operation.resultsLimit = resultsLimit ?? CKQueryOperation.maximumResults
            operation.desiredKeys = desiredKeys
            operation.qualityOfService = .userInitiated

            operation.queryCompletionBlock = { [weak self] cursor, error in
                if let error = error as? CKError {
                    self?.handleError(error, in: operation)
                } else if let error = error {
                    self?.subscriber?.receive(completion: .failure(error))
                } else {
                    if let cursor = cursor {
                        guard let self = self else { return }
                        let operation = CKQueryOperation(cursor: cursor)
                        self.configureOperation(operation)
                        self.operationQueue.addOperation(operation)
                    }

                    self?.subscriber?.receive(completion: .finished)
                }
            }

            operation.recordFetchedBlock = { [weak self] record in
                _ = self?.subscriber?.receive(record)
            }
        }

        /// Handle CloudKit errors.
        ///
        /// - Parameter error: The error to handle.
        private func handleError(_ error: CKError, in operation: CKQueryOperation) {
            if let retryDelay = error.retryAfterSeconds {
                operationQueue.schedule(after: .init(Date() + retryDelay)) { [weak self] in
                    self?.configureOperation(operation)
                }
            } else {
                subscriber?.receive(completion: .failure(error))
            }
        }
    }
}

// MARK: -

extension CKQueryOperation.Publisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
        operationQueue.cancelAllOperations()
    }
}

extension CKQueryOperation.Publisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        guard demand != .none,
              subscriber != nil
        else { return }

        queue.async {
            let operation = CKQueryOperation(query: self.query)
            self.configureOperation(operation)
            self.operationQueue.addOperation(operation)
        }
    }
}
