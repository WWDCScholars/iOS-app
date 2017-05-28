//
//  ScholarClusterAnnotationView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import MapKit

internal final class ScholarClusterAnnotationView: MKAnnotationView {
    
    // MARK: - Private Properties
    
    private let label = UILabel()
    private let size = CGSize(width: 30.0, height: 30.0)
    
    // MARK: - Lifecycle
    
    internal override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.styleUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.roundCorners()
        self.applyRelativeCircularBorder()
        self.backgroundColor = .scholarsPurple
        
        self.label.applyScholarClusterStyle()
    }
    
    private func configureUI() {
        self.frame.size = self.size
        self.canShowCallout = false
        
        self.label.frame = self.frame
        self.addSubview(self.label)
    }
    
    // MARK: - Internal Functions
    
    internal func setLabel(text: String) {
        self.label.text = text
    }
}
