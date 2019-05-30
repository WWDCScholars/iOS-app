//
//  ScholarsViewControllerProxy.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal protocol ScholarsViewControllerProxyDelegate: class {
    var proxy: ScholarsViewControllerProxy? { get set }

    func didLoad(basicScholar: Scholar)
    func didLoad(scholars: [Scholar])
    func didLoadWWDCYearInfo()
    func didLoadBatch()
}

internal final class ScholarsViewControllerProxy {

    // MARK: - Private Properties

    private weak var delegate: ScholarsViewControllerProxyDelegate?

    // MARK: - Lifecycle

    internal init(delegate: ScholarsViewControllerProxyDelegate) {
        self.delegate = delegate
    }

    // MARK: - Internal Functions
    internal func loadListScholars(batchInfo: WWDCYear) {
        DispatchQueue.global(qos: .background).async {
            let scholars = CKDataController.shared.scholars(for: batchInfo)
            DispatchQueue.main.async {
                self.delegate?.didLoad(scholars: scholars)
                self.delegate?.didLoadWWDCYearInfo()
                self.delegate?.didLoadBatch()
            }
        }
    }

    private func basicScholarFetched(basicScholar: Scholar) {
        self.delegate?.didLoad(basicScholar: basicScholar)
    }
}

func didLoadWWDCYearInfo() {
    // TODO: O
}

