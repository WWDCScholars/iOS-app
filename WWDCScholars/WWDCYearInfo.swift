//
//  WWDCYearInfo.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal class WWDCYearInfo {
    internal var id: UUID
    
    internal var scholarId: UUID?
    internal var wwdcYear: WWDCYear
    
    internal let profilePictureUrl: URL
    internal let acceptanceEmail: URL?
    internal let videoUrl: URL?
    internal let screenshots: [URL]
    internal let githubAppUrl: URL?
    
    internal let appType: AppType
    internal let appStoreSubmissionUrl: URL?
    
    internal let appliedAs: ApplicantType

    required init(record: [String: Any]) {
        id = record["id"] as! UUID
        scholarId  = record["scholarId"] as? UUID
        wwdcYear = record["year"] as! WWDCYear
        profilePictureUrl = record["profilePictureUrl"] as! URL
        acceptanceEmail = record["acceptanceEmailUrl"] as! URL?
        screenshots = record["screenshots"] as! [URL]
        videoUrl = record["videoUrl"] as? URL
        githubAppUrl = record["githubAppUrl"] as? URL
        appType = record["appType"] as! AppType
        appStoreSubmissionUrl = record["appStoreSubmissionUrl"] as! URL?
        appliedAs = record["appliedAs"] as! ApplicantType
    }
    
}
