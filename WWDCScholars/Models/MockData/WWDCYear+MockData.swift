//
//  WWDCYear+MockData.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 29.07.21.
//

#if DEBUG
extension WWDCYear {
    static let mockData: [WWDCYear] = [
        .init(
            recordName: "WWDC 2018",
            name: "WWDC 2018",
            year: "2018",
            challengeDescription: nil
        ),
        .init(
            recordName: "WWDC 2019",
            name: "WWDC 2019",
            year: "2019",
            challengeDescription: nil
        ),
        .init(
            recordName: "WWDC 2020",
            name: "WWDC 2020",
            year: "2020",
            challengeDescription: nil
        ),
        .init(
            recordName: "WWDC 2021",
            name: "WWDC 2021",
            year: "2021",
            challengeDescription: "In 2021, applicants were tasked with building an interactive playground to showcase their creativity and technical abilities."
        )
    ]
}
#endif
