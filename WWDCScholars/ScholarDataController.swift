//
//  ScholarDataController.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 18/12/2018.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import Foundation

protocol ScholarDataController {
    /// Returns all scholars for a given year with a given status
    ///
    /// - Parameters:
    ///   - year: WWDC year to get the scholars for
    ///   - status: Optional status of the scholars returned
    /// - Returns: An array of scholars with given year and status
    func scholars(`for` year: WWDCYear, with status: Scholar.Status?) -> [Scholar]
    
    /// Gets a scholar identified by the id
    ///
    /// - Parameter id: Identifier of the scholar to retrieve
    /// - Returns: Returns the scholar with given id or nil
    func scholar(for id: UUID) -> Scholar?
    
    /// Returns the data for a scholar of a certain year
    ///
    /// - Parameters:
    ///   - year: The year to get the data for
    ///   - scholar: Scholar to get the data for
    func scholarData(for year: WWDCYear, scholar: Scholar) -> Batch?
    
    /// Returns the amount of scholars in the database
    /// for the given year
    ///
    /// - Parameter year: Optional year to count the scholars for
    /// - Returns: The number of scholars for a given year in the database
    func countScholars(for year: WWDCYear?) -> Int
    
    /// Add scholar to the database
    ///
    /// - Parameter scholar: Scholar to add
    func add(_ scholar: Scholar)
    
    /// Removes scholar from a database
    ///
    /// - Parameter scholar: Scholar to remove
    func remove(_ scholar: Scholar)
    
    /// Update scholar in database
    ///
    /// - Parameter scholar: Scholar to update
    func update(_ scholar: Scholar)
}

protocol ScholarIterator: IteratorProtocol where Element == Scholar {
    init(_ wwdcYear: WWDCYear)
}
