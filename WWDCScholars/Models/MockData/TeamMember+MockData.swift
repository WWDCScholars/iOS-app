//
//  TeamMember+MockData.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.06.21.
//

import CloudKit
import Foundation
import UIKit

#if DEBUG
extension TeamMember {
    static let mockData: [TeamMember] = [
        .init(
            recordName: "6BCC1AE2-3689-EADF-CD98-1137A1B13EA0",
            name: "Andrew Walker",
            biography: "Andrew has been working on iOS applications for 4 1/2 years. He recently interned at Apple after attending WWDC as a scholarship winner for three consecutive years.",
            birthday: Date(timeIntervalSince1970: 845856000),
            picture: UIImage(named: "profile-picture-andrew"),
            isActive: false,
            scholar: .init(recordID: .init(recordName: "CAA0AC95-E07D-4648-85BE-AE727440BD34"), action: .none)
        ),
        .init(
            recordName: "5F0A3521-BBC3-EE22-4980-4C1985F8A8F3",
            name: "Michie Ang",
            biography: "Michie was a nurse when she first got into iOS development. She won a scholarship three times, builds tech communities and travels around to inspire others to learn programming.",
            birthday: Date(timeIntervalSince1970: 845856000),
            picture: UIImage(named: "profile-picture-michie"),
            isActive: true,
            scholar: .init(recordID: .init(recordName: "4A4B50FA-4D81-49E5-B38A-7AB4B5710BA1"), action: .none)
        ),
        .init(
            recordName: "B91012A0-6CC2-8960-67E3-8012A0733DC5",
            name: "Moritz Sternemann",
            biography: "Moritz is the most recent addition to our team and mostly worked on our website and the signup form. He attended WWDC as a scholarship winner for three years.",
            birthday: Date(timeIntervalSince1970: 845856000),
            picture: UIImage(named: "profile-picture-moritz"),
            isActive: true,
            scholar: .init(recordID: .init(recordName: "4B12EC83-9A0A-44F2-A815-D4A99AA7D208"), action: .none)
        ),
        .init(
            recordName: "D9976C96-DFCE-69E1-C281-9CFA83F6C06D",
            name: "Sam Eckert",
            biography: "Sam started developing iOS apps when he turned 14. He received two WWDC scholarships and is now building great apps at vectornator.io",
            birthday: Date(timeIntervalSince1970: 845856000),
            picture: UIImage(named: "profile-picture-sam"),
            isActive: true,
            scholar: .init(recordID: .init(recordName: "3DC4AA81-48FC-4CD3-AF2D-0C74B73489B6"), action: .none)
        ),
        .init(
            recordName: "9BA79752-3483-A405-AF95-A3DE67473AD1",
            name: "Oliver Binns",
            biography: nil,
            birthday: nil,
            picture: nil,
            isActive: false,
            scholar: nil
        ),
        .init(
            recordName: "EB1AE4BF-DA09-59AF-42B4-8B28605B3A15",
            name: "Matthijs Logemann",
            biography: nil,
            birthday: nil,
            picture: nil,
            isActive: false,
            scholar: nil
        ),
        .init(
            recordName: "14B73801-B692-5420-D69E-2F0AB9652055",
            name: "Gregg Mojica",
            biography: nil,
            birthday: nil,
            picture: nil,
            isActive: false,
            scholar: nil
        )
    ]
}
#endif
