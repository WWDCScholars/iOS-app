//
//  ScholarSocialMedia+MockData.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 11.06.21.
//

import CloudKit

//#if DEBUG
extension ScholarSocialMedia {
    static let mockData: [ScholarSocialMedia] = [
        .init(
            recordName: "D9A2B77D-8279-4E40-8906-318F74605990",
            discord: "strnmn#2921",
            facebook: "https://facebook.com/iMoritzS",
            github: "https://github.com/moritzsternemann",
            imessage: "iMoritz@icloud.com",
            instagram: "https://instagram.com/moritzsternemann",
            itunes: "https://apps.apple.com/us/developer/corporatr/id1355679474",
            linkedin: "https://linkedin.com/in/moritzsternemann",
            twitter: "http://twitter.com/strnmn",
            website: "https://moritzsternemann.de",
            scholar: .init(recordID: .init(recordName: "4B12EC83-9A0A-44F2-A815-D4A99AA7D208"), action: .none)
        )
    ]
}
//#endif
