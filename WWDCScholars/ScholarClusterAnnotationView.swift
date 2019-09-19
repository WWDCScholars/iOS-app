//
//  ScholarClusterAnnotationView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import MapKit

final class ScholarClusterAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let _ = newValue as? MKClusterAnnotation else { return }
            markerTintColor = .scholarsPurple
        }
    }
    
//    // MARK: - Private Properties
//
//    private let label = UILabel()
//    private let size = CGSize(width: 30.0, height: 30.0)
//
//    // MARK: - Lifecycle
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//
//        configureUI()
//        styleUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - UI
//
//    private func styleUI() {
//        roundCorners()
//        applyRelativeCircularBorder()
//        backgroundColor = .scholarsPurple
//
//        label.applyScholarClusterStyle()
//    }
//
//    private func configureUI() {
//        canShowCallout = false
//        frame.size = size
//
//        label.frame = frame
//        addSubview(label)
//    }
//
//    // MARK: - Functions
//
//    func setLabel(text: String) {
//        self.label.text = text
//    }
}
