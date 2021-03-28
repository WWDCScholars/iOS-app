//
//  CKQueryOperation+Publisher.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 21.03.21.
//

import CloudKit
import Combine

extension CKQueryOperation {
    class func publisher(
        for query: CKQuery,
        resultsLimit: Int = CKQueryOperation.maximumResults,
        in database: CKDatabase,
        on queue: DispatchQueue
    ) -> CKQueryOperation.Publisher {
        return CKQueryOperation.Publisher(
            for: query,
            resultsLimit: resultsLimit,
            in: database,
            on: queue
        )
    }
}

extension CKQueryOperation {
    /// A publisher that wraps a `CKQueryOperation` and emits events as the operation completes.
    struct Publisher: Combine.Publisher {
        // MARK: Types

        /// The events emitted by the publisher.
        enum Action {
            /// Posted when a record is received from the server.
            case recordFetched(CKRecord)

            /// Indicates there are more results to fetch. Initialize a new query operation object when you are ready to retrieve the next batch of results.
            case moreAvailable(CKQueryOperation.Cursor)
        }

        // MARK: Properties

        /// The query to perform.
        private let query: CKQuery

        /// The maximum number of results.
        private let resultsLimit: Int

        /// The CloudKit database to perform the operation on.
        private let database: CKDatabase

        /// Underlying queue to run the operation on.
        private let queue: DispatchQueue

        // MARK: Initialization

        /// Creates a new `CKQueryOperation.Publisher`.
        ///
        /// - Parameters:
        ///     - query: The query to perform.
        ///     - resultsLimit: The maximum number of results.
        ///     - database: The CloudKit database to perform the operation on.
        ///     - queue: Underlying queue to run the operation on.
        init(
            for query: CKQuery,
            resultsLimit: Int = CKQueryOperation.maximumResults,
            in database: CKDatabase,
            on queue: DispatchQueue
        ) {
            self.query = query
            self.resultsLimit = resultsLimit
            self.database = database
            self.queue = queue
        }

        // MARK: Publisher Implementation

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(
                subscriber: subscriber,
                for: query,
                resultsLimit: resultsLimit,
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

extension CKQueryOperation.Publisher {
    /// The subscription that wraps the actual operation execution and emits actions to its subscriber.
    final class Subscription<S: Subscriber> where S.Input == Output, S.Failure == Failure {
        // MARK: Properties

        /// The subscriber to notify of events.
        private var subscriber: S?

        /// The query to perform
        private let query: CKQuery

        /// The maximum number of results.
        private let resultsLimit: Int

        /// The CloudKit database to perform the operation on.
        private let database: CKDatabase

        /// Underlying queue to run the operation.
        private let queue: DispatchQueue

        /// An operation queue to run all operations on.
        private let operationQueue: OperationQueue

        /// The operation when in flight.
        private var operation: CKQueryOperation?

        // MARK: Initialization

        init(
            subscriber: S,
            for query: CKQuery,
            resultsLimit: Int,
            in database: CKDatabase,
            on queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.query = query
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
        private func configureOperation() {
            let operation = CKQueryOperation(query: query)

            operation.database = database
            operation.resultsLimit = resultsLimit
            operation.qualityOfService = .userInitiated

            operation.queryCompletionBlock = { [weak self] cursor, error in
                if let error = error as? CKError {
                    self?.handleError(error)
                } else if let error = error {
                    self?.subscriber?.receive(completion: .failure(error))
                } else {
                    if let cursor = cursor {
                        _ = self?.subscriber?.receive(.moreAvailable(cursor))
                    }

                    self?.subscriber?.receive(completion: .finished)
                }
            }

            operation.recordFetchedBlock = { [weak self] record in
                _ = self?.subscriber?.receive(.recordFetched(record))
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

extension CKQueryOperation.Publisher.Subscription: Cancellable {
    func cancel() {
        subscriber = nil
        operation?.cancel()
    }
}

extension CKQueryOperation.Publisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        guard subscriber != nil,
              operation == nil,
              demand > 0
          else { return }

        configureOperation()
    }
}
