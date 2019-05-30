//
//  ScholarCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit
import Nuke

internal final class ScholarCollectionViewCell: UICollectionViewCell, Cell {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var labelContainerView: UIView?
    @IBOutlet private weak var label: UILabel?
    
    // MARK: - Internal Properties
    
    internal var cellContent: CellContent?
    
    // MARK: - Lifecycle
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyDefaultCornerRadius()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.labelContainerView?.backgroundColor = .thumbnailTransparentPurple
        self.label?.applyScholarsTitleStyle()
        self.imageView?.tintColor = .backgroundElementGray
    }
    
    // MARK: - Internal Functions
    
    internal func configure(with cellContent: CellContent) {
        self.cellContent = cellContent
        
        guard let cellContent = cellContent as? ScholarCollectionViewCellContent else {
            return
        }
		
        self.label?.text = cellContent.scholar.givenName
        
        self.imageView?.image = UIImage.loading
        self.imageView?.contentMode = .center
        
        Nuke.loadImage(with: (cellContent.scholar.profilePicture?.fileURL!)!, into: self.imageView!)

//        cellContent.scholar.profilePictureLoaded.append({
//            error in
//            guard error == nil else { return }
//            
//            DispatchQueue.main.async {
//                self.imageView?.image = cellContent.scholar.profilePicture?.image
//                self.imageView?.contentMode = .scaleAspectFill
//            }
//        })
//        cellContent.scholar.loadProfilePicture()
    }
}
