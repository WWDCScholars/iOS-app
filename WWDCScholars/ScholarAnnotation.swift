//
//  JobNotation.swift
//  QuestBoard
//
//  Created by Gelei Chen on 15/3/16.
//  Copyright (c) 2015年 Purdue Bang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ScholarAnnotation: NSObject, MKAnnotation, QTreeInsertable {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var id: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, id: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.id = id
    }
}

