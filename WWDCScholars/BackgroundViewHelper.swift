//
//  BackgroundViewControllerHelper.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BackgroundViewHelper {
    
    // MARK: - Private Properties
    
    private var activeViewController: UIViewController?
    private var containerView: UIView?
    
    // MARK: - Lifecycle
    
    internal init(containerView: UIView?) {
        self.containerView = containerView
    }
    
    // MARK: - Internal Functions
    
    internal func presentActivityView(text: String? = nil) {
        let viewController = self.viewController(with: "BackgroundActivityViewController") as? BackgroundActivityViewController
        viewController?.text = text
        self.present(viewController)
    }
    
    internal func dismiss() {
        self.activeViewController?.view.removeFromSuperview()
        self.activeViewController = nil
    }
    
    // MARK: - Private Functions
    
    private func viewController(with identifier: String) -> UIViewController {
        let bundle = Bundle(for: BackgroundViewHelper.self)
        let storyboard = UIStoryboard(name: "BackgroundViewControllers", bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    
    private func present(_ viewController: UIViewController?) {
        guard let containerView = self.containerView, let view = viewController?.view else {
            return
        }
        
        self.dismiss()
        self.activeViewController = viewController
        view.frame = containerView.frame
        containerView.addSubview(view)
    }
}
