//
//  WWDCYearInfo+MockData.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

import CloudKit

#if DEBUG
extension WWDCYearInfo {
    static let mockData: [WWDCYearInfo] = [
        .init(
            recordName: "9A4CBAD9-9909-4434-9FE5-ED6C0C35A0F8",
            acceptanceEmail: nil,
            appliedAs: "student",
            description: "As I took a lot of interest in teaching software engineering topics over that past few years, I wanted to teach something in my playground.\nI created a custom assembly language that is inspired by existing ones like the Intel x86 assembler but reduced in complexity so that it can be quickly understood and used.\nTo run programs written in this language within Swift Playgrounds, I built a parser and interpreter.",
            status: "approved",
            screenshots: [],
            githubLink: "https://github.com/WWDCScholars/web-app",
            videoLink: "https://vimeo.com/524933864",
            appstoreLink: "https://apps.apple.com/us/app/wwdcscholars/id1459158255",
            appType: "offline",
            reviewedAt: Date(timeIntervalSince1970: 1609010700000),
            reviewedBy: .init(recordID: .init(recordName: "4B12EC83-9A0A-44F2-A815-D4A99AA7D208"), action: .none),
            scholar: .init(recordID: .init(recordName: "4B12EC83-9A0A-44F2-A815-D4A99AA7D208"), action: .none),
            year: .init(recordID: .init(recordName: "WWDC 2021"), action: .none)
        )
    ]
}
#endif
