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

    @MainActor
    func testButtonsAndLinks() async throws {
        await matcher.match {
            TabView {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Image(systemName: "camera.macro.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .accessibilityLabel("Photo")

                            Button(action: {}) {
                                Text("Save")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }

                            Button(action: {}) {
                                Image(systemName: "camera")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            .accessibilityLabel("Camera")

                            Button(action: {}) {
                                Text("Button Link Title")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            .accessibilityAddTraits(.isLink)

                            NavigationLink {
                                Text("Destination")
                            } label: {
                                Text("Navigation Link")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                    }
                    .background(Color.yellow.opacity(0.1))
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: { }) {
                                Image(systemName: "square.and.pencil")
                            }
                            .accessibilityLabel("Edit")

                            Button(action: { }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .accessibilityLabel("Share")
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }

                Text("Dummy Tab Content")
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
            }
        }
    }

}
