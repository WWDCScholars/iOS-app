//
//  CLPlacemark+MockData.swift
//  CLPlacemark+MockData
//
//  Created by Moritz Sternemann on 29.07.21.
//

import Contacts
import MapKit

#if DEBUG
extension CLPlacemark {
    enum MockData {
        static let applePark: CLPlacemark = {
            let address = CNMutablePostalAddress()
            address.city = "Cupertino"
            address.state = "CA"
            address.country = "United States"

            return MKPlacemark(
                coordinate: .init(latitude: 37.334900, longitude: -122.009020),
                postalAddress: address
            )
        }()
    }
}
#endif
