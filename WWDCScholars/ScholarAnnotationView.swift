//
//  ScholarAnnotationView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import MapKit

final class ScholarAnnotationView: MKAnnotationView {
    
    // MARK: - Private Properties
    
    private let imageView = UIImageView()
    private let size = CGSize(width: 50.0, height: 50.0)

    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? ScholarAnnotation else { return }
            setImage(annotation.image)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        styleUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    
    // MARK: - UI
    
    private func styleUI() {
        backgroundColor = .scholarsPurple
        roundCorners()
        applyRelativeCircularBorder()
        
        imageView.roundCorners()
    }
    
    private func configureUI() {
        canShowCallout = false
        clusteringIdentifier = K.scholarClusterAnnotationReuseIdentifier
        displayPriority = .required
        collisionMode = .circle

        frame.size = size
        
//        imageView.image = UIImage(named: "profile")
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
    }
	
    private func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
	}
}
