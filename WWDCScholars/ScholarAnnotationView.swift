//
//  ScholarAnnotationView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 20/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import MapKit

fileprivate extension K {
    static let viewSize: CGFloat = 40.0
    static let selectedSizeFactor: CGFloat = 1.5
    static let imageBorderWidth: CGFloat = 3.0
}

final class ScholarAnnotationView: MKAnnotationView {
    
    // MARK: - Private Properties

    private let contentView = UIView()
    private let imageView = UIImageView()

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bounds = contentView.bounds
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureCorners()
    }

    override func prepareForReuse() {
        imageView.image = nil
        bounds = contentView.bounds
    }
    
    // MARK: - UI

    private func configureUI() {
        canShowCallout = false
        clusteringIdentifier = K.scholarClusterAnnotationReuseIdentifier
        displayPriority = .required
        collisionMode = .circle

        contentView.backgroundColor = .scholarsPurple
        contentView.layoutMargins = UIEdgeInsets(top: K.imageBorderWidth, left: K.imageBorderWidth, bottom: K.imageBorderWidth, right: K.imageBorderWidth)
        contentView.bounds.size = CGSize(width: K.viewSize, height: K.viewSize)
        addSubview(contentView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        bounds = contentView.bounds
    }
    
    private func configureCorners() {
        contentView.roundCorners()
        imageView.roundCorners()
    }
	
    private func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
	}
}
