import XCTest
import SwiftUI
import Stilleben

final class A11yTests: XCTestCase {
    private let matcher = UIMatcher()
        .assertSimulator(modelIdentifier: "iPhone14,7")
        .rendering(.a11y(hosted: false))
        .sizing(.screen)
        .dynamicTypeSizes(.large)
        .colorSchemes(.light)

    func testButtonsAndLinks() async throws {
        await matcher.match {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Button(action: {}) {
                            Text("Button 1 Title")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }

                        Button(action: {}) {
                            Text("Button 2 Title")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .accessibilityLabel("Custom a11y")

                        Button(action: {}) {
                            Text("Button Link Title")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .accessibilityAddTraits(.isLink)

                        NavigationLink {
                            EmptyView()
                        } label: {
                            Text("Navigation Link")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }

}
