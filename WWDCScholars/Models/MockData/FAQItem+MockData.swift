//
//  FAQItem+MockData.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.06.21.
//

#if DEBUG
extension FAQItem {
    static let mockData: [FAQItem] = [
        .init(
            recordName: "74C7A5DF-26C1-1E3D-18E1-FA68B305087E",
            index: 1,
            question: "What is a WWDC Scholarship?",
            comment: nil,
            answer: """
                The [Apple Worldwide Developers Conference (WWDC)](https://developer.apple.com/wwdc/) is a conference held annually in California by Apple Inc. The event gathers approximately 5000 developers in one place to learn about and discuss the latest software and technologies for Apple platform developers. Attendees can participate in hands-on labs with Apple engineers, and in-depth sessions covering a wide variety of topics.

                Every year, Apple rewards up to 350 talented students and STEM organization members with an opportunity to attend the conference as a scholarship winner. Individuals selected for a scholarship will receive a WWDC ticket, lodging for the conference, and one year of membership in the Apple Developer Program free of charge.
                """
        ),
        .init(
            recordName: "5B85EB3F-4A81-9CE9-761D-B2E4D160AD40",
            index: 2,
            question: "How can I apply?",
            comment: "Due to being held online, the WWDC Scholarship is called Swift Student Challenge in 2021. WWDC 2022 has not been announced yet. Don't miss any announcements by [following us on Twitter (@WWDCScholars)](https://twitter.com/WWDCScholars).",
            answer: "The application for a WWDC scholarship consists of a combination of a Swift Playground to showcase your ingenuity and written responses to a few questions. You can [find out more on the WWDC Website](https://developer.apple.com/wwdc21/swift-student-challenge/)."
        ),
        .init(
            recordName: "7B794902-B828-3E2D-7319-C12B6B418C6F",
            index: 3,
            question: "How do I join WWDCScholars?",
            comment: nil,
            answer: """
                If you are a WWDC Scholarship / Swift Student Challenge winner, you can [sign up to create a profile on our website](https://join.wwdcscholars.com/). This is a great way to connect with fellow Scholars and help you to get the most out of the conference.

                Typically it takes us some time to update the signup form each year so it might not be available immediately after results are out. Be sure to [follow us on Twitter (@WWDCScholars) to stay up to date.](https://twitter.com/WWDCScholars).
                """
        ),
        .init(
            recordName: "3F710F6F-82AE-7347-D3F0-90EA42128C0E",
            index: 4,
            question: "Is there anything I can help with?",
            comment: nil,
            answer: "We are always on the lookout for creative individuals and like-minded developers from all around the world to help us build our platform for WWDC scholarship winners. Our current projects include a native iOS app written in Swift as well as two Vue.js web applications for signup and this website. Everything we develop is openly [available on GitHub](https://github.com/WWDCScholars). If you are interested in contributing to any of our projects, check out the open issues of the respective repository, or create a new one to suggest an improvement or request a feature."
        )
    ]
}
#endif
