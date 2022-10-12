import XCTest
import SwiftUI
import Stilleben

final class SwiftUITests: XCTestCase {
    private let matcher = UIMatcher()
        .assertSimulator(modelIdentifier: "iPhone10,4")
        .sizing(.dynamicHeight)

    func testSimpleText() async throws {
        await matcher
            .sizing(.intrinsic)
            .locales(.english, .swedish)
            .includeDeviceName()
            .match {
                Text("Hello World!", bundle: .module)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
    }

    func testNavigation() async throws {
        await matcher
            .sizing(.screen)
            .match {
                NavigationView {
                    Text("Content View")
                        .navigationTitle("Title")
                }
            }
    }

    func testShortScrollview() async throws {
        await matcher.match {
            ItemList(count: 3)
                .background(Color(UIColor.systemBackground))
        }
    }

    func testLongScrollview() async throws {
        await matcher.match {
            ItemList(count: 25)
                .background(Color(UIColor.systemBackground))
        }
    }

    func testLongScrollviewInNavigationView() async throws {
        await matcher.match {
            NavigationView {
                ScrollView {
                    ItemList(count: 25)
                }
                .navigationTitle("List of items")
            }
        }
    }

    func testLongScrollviewInTabView() async {
        await matcher.match {
            TabView {
                NavigationView {
                    ScrollView {
                        ItemList(count: 25)
                    }
                    .navigationTitle("List of items")
                }
                .tabItem {
                    Label("List", systemImage: "list.number")
                }
            }
        }
    }
}
