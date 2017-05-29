//
//  ScholarCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

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
    }
    
    // MARK: - Internal Functions
    
    internal func configure(with cellContent: CellContent) {
        self.cellContent = cellContent
        
        guard let cellContent = cellContent as? ScholarCollectionViewCellContent else {
            return
        }
        
        self.label?.text = cellContent.scholar.firstName
        self.imageView?.image = cellContent.scholar.profileImage
    }
}
