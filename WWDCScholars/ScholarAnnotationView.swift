//
//  ScholarAnnotationView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit
import MapKit

internal final class ScholarAnnotationView: MKAnnotationView {
    
    // MARK: - Private Properties
    
    private let imageView = UIImageView()
    private let size = CGSize(width: 50.0, height: 50.0)
    
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
        
        self.imageView.roundCorners()
    }
    
    private func configureUI() {
        self.frame.size = self.size
        self.canShowCallout = false
        
        self.imageView.image = UIImage(named: "profile")
        self.imageView.frame = self.frame
        self.addSubview(self.imageView)
    }
}
