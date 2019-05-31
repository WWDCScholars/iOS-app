//
//  WWDCYearInfoCollectionViewCell.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class WWDCYearInfoCollectionViewCell: UICollectionViewCell, Cell {
    
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
        self.label?.applyScholarsWWDCYearInfoTitleStyle()
    }
    
    // MARK: - Internal Functions
    
    internal func configure(with cellContent: CellContent) {
        self.cellContent = cellContent
        
        guard let cellContent = cellContent as? WWDCYearInfoCollectionViewCellContent else {
            return
        }
        
        self.label?.text = cellContent.batchInfo.title
        self.backgroundColor = cellContent.isSelected ? .selectedTransparentWhite : .clear
    }
}
