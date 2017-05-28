//
//  BatchCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class BatchCollectionViewCell: UICollectionViewCell, Cell {
    
    // MARK: - Private Properties
    
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
        
        self.roundCorners()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.label?.applyScholarsBatchTitleStyle()
    }
    
    // MARK: - Internal Functions
    
    internal func configure(with cellContent: CellContent) {
        self.cellContent = cellContent
        
        guard let cellContent = cellContent as? BatchCollectionViewCellContent else {
            return
        }
        
        self.label?.text = cellContent.batch.title
        self.backgroundColor = cellContent.isSelected ? .selectedTransparentWhite : .clear
    }
}
