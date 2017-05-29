//
//  ContainerViewController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 26/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

@objc internal protocol ContainerViewController: class {
    @objc optional func switchedToViewController()
    @objc optional func switchedFromViewController()
}
