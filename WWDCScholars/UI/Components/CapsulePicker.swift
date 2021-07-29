//
//  CapsulePicker.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 24.03.21.
//

import SwiftUI

// MARK: - View

fileprivate enum Constants {
    static let activeSegmentColor: Color = Color(.init(white: 1, alpha: 0.2))
    static let textColor: Color = .white

    static let textFont: Font = .system(size: 14)

    static let segmentSize: CGSize = .init(width: 70, height: 30)
    static let segmentSpacing: CGFloat = 8
    static let pickerPadding: CGFloat = 8

    static let animationDuration: Double = 0.1
}

struct CapsulePicker<SelectionValue>: View where SelectionValue: Hashable {
    typealias Element = (label: String, id: SelectionValue)

    private let data: [Element]
    @Binding private var selection: SelectionValue

    init(
        _ data: [Element],
        selection: Binding<SelectionValue>
    ) {
        self.data = data
        _selection = selection
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: Constants.segmentSpacing) {
                    ForEach(data, id: \.id.self) { element in
                        segmentView(for: element, scrollProxy: proxy)
                            .frame(width: Constants.segmentSize.width, height: Constants.segmentSize.height)
                    }
                }
                .onAppear { scrollToItem(with: selection, scrollProxy: proxy, animated: false) }
                .onChange(of: selection) { scrollToItem(with: $0, scrollProxy: proxy) }
            }
        }
        .padding(.horizontal, Constants.pickerPadding)
    }

    private func segmentView(for element: Element, scrollProxy: ScrollViewProxy) -> some View {
        return ZStack {
            Capsule()
                .foregroundColor(selection == element.id ? Constants.activeSegmentColor : .clear)
                .animation(Animation.linear(duration: Constants.animationDuration))
            Text(element.label)
                .foregroundColor(Constants.textColor)
                .lineLimit(1)
        }
        .id(element.id)
        .onTapGesture { onSegmentTapped(with: element.id, scrollProxy: scrollProxy) }
    }

    private func onSegmentTapped(with id: SelectionValue, scrollProxy: ScrollViewProxy) {
        selection = id
        scrollToItem(with: id, scrollProxy: scrollProxy)
    }

    private func scrollToItem(with value: SelectionValue, scrollProxy: ScrollViewProxy, animated: Bool = true) {
        if animated {
            withAnimation(.linear(duration: Constants.animationDuration)) {
                scrollProxy.scrollTo(value)
            }
        } else {
            scrollProxy.scrollTo(value)
        }
    }
}

// MARK: - Previews

struct CapsulePicker_Previews: PreviewProvider {
    @State static var selection: String = "WWDC 2020"

    static let years = [
        (label: "2015", id: "WWDC 2015"),
        (label: "2016", id: "WWDC 2016"),
        (label: "2017", id: "WWDC 2017"),
        (label: "2018", id: "WWDC 2018"),
        (label: "2019", id: "WWDC 2019"),
        (label: "2020", id: "WWDC 2020")
    ]

    static var previews: some View {
        CapsulePicker(years, selection: $selection)
            .frame(width: 375, height: 30)
            .background(Color.theme.brand)
    }
}
