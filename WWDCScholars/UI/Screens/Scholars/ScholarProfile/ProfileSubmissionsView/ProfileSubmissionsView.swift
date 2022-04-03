//
//  ProfileSubmissionsView.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 27.03.22.
//

import SwiftUI

struct ProfileSubmissionsView: View {
    static let spellOutNumberFormatter = configure(NumberFormatter()) {
        $0.numberStyle = .spellOut
    }

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Scholarships")
                .font(.title2.bold())
                .foregroundColor(.theme.brand)

            Text(submissionsDescription)
                .font(.callout.italic())
                .foregroundColor(.secondary)

            if viewModel.scholar.wwdcYearsApproved.count > 1 {
                ProfileSubmissionsYearPickerView(viewModel: viewModel.yearPickerViewModel, selectedYear: $viewModel.routingState.selectedYear)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.theme.brand)
            }

            ProfileSubmissionView(viewModel: .init(
                container: viewModel.container,
                scholar: viewModel.scholar,
                yearRecordName: viewModel.routingState.selectedYear
            ))
        }
    }

    private var submissionsDescription: AttributedString {
        let yearCount = viewModel.scholar.wwdcYearsApproved.count

        var yearCountMorphology = Morphology()
        yearCountMorphology.number = .init(exactNumber: yearCount)
        let yearCountInflectionRule = InflectionRule.explicit(yearCountMorphology)

        var string = AttributedString()
        if yearCount > 1 {
            var yearsString = AttributedString(localized: "\(viewModel.scholar.givenName) has been awarded a WWDC scholarship \(yearCount, formatter: Self.spellOutNumberFormatter) time.")

            if let rangeTime = yearsString.range(of: "time") {
                var morphology = yearCountMorphology
                morphology.partOfSpeech = .noun
                yearsString[rangeTime].inflect = .explicit(morphology)
            }

            string.append(yearsString.inflected())
        } else if let year = viewModel.scholar.wwdcYearsApproved.first {
            let yearString = AttributedString(localized: "\(viewModel.scholar.givenName) has been awarded a WWDC scholarship in \(String(year.recordID.recordName.suffix(4))).")
            string.append(yearString.inflected())
        } else {
            return AttributedString(localized: "\(viewModel.scholar.givenName) has not been awarded a WWDC scholarship yet.")
        }

        var submissionsString = AttributedString(localized: "Here is the submission that got them there.")

        if let rangeIs = submissionsString.range(of: "is") {
            submissionsString[rangeIs].inflect = yearCountInflectionRule
        }
        if let rangeSubmission = submissionsString.range(of: "submission") {
            submissionsString[rangeSubmission].inflect = yearCountInflectionRule
        }
        if let rangeThem = submissionsString.range(of: "them") {
            var morphology = Morphology()
            morphology.grammaticalGender = viewModel.scholar.gender.grammaticalGender
            submissionsString[rangeThem].inflect = .explicit(morphology)
        }

        string.append(AttributedString(" "))
        string.append(submissionsString.inflected())

        return string
    }
}

// MARK: - Preview

#if DEBUG
struct ProfileSubmissionsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSubmissionsView(viewModel: .init(container: .preview, scholar: Scholar.mockData[0]))
    }
}
#endif

// MARK: -

extension String.LocalizationValue.StringInterpolation {
    mutating func appendInterpolation<Value: BinaryInteger>(_ number: Value, formatter: NumberFormatter) {
        if let value = number as? NSNumber, let string = formatter.string(from: value) {
            appendLiteral(string)
        } else {
            appendLiteral("\(number)")
        }
    }
}
