import XCTest
import SwiftUI
import Stilleben

final class SwiftUITests: XCTestCase {
    private let matcher = UIMatcher()
        .assertSimulator(modelIdentifier: "iPhone14,7")
        .sizing(.dynamicHeight)

    func testSimpleText() async throws {
        await matcher
            .sizing(.intrinsic)
            .locales(.english, .swedish)
            .includeDeviceName()
            .match {
                Text("Hello World!", bundle: .module)
                    .padding()
                    .background(.background)
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
        await matcher
            .ignoresSafeArea()
            .match {
                ItemList(count: 3)
                    .background(.background)
            }
    }

    func testLongScrollview() async throws {
        await matcher
            .ignoresSafeArea()
            .match {
                ItemList(count: 25)
                    .background(.background)
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
    
    func testDelayedSnapshot() async {
        let matcher = self.matcher
            .dynamicTypeSizes(.large)
            .colorSchemes(.light)
            .sizing(.intrinsic)
            .delay(.milliseconds(200))
        
        await matcher.match {
            LightBulb()
        }
    }
    
    private struct LightBulb: View {
        @State var isOn = false
        
        var body: some View {
            HStack {
                Image(systemName: "lightbulb")
                Image(systemName: isOn ? "lightbulb.fill" : "lightbulb")
                    .task {
                        try? await Task.sleep(nanoseconds: 100_000_000)
                        isOn = true
                    }
            }
        }
    }
}
