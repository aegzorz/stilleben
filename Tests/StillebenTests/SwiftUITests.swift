import XCTest
import SwiftUI
import Stilleben

final class SwiftUITests: XCTestCase {
    func testSimpleText() async throws {
        await SwiftUIMatcher()
            .sizing(.intrinsic)
            .match {
                Text("Hello World!")
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
    }

    func testNavigation() async throws {
        await SwiftUIMatcher()
            .match {
                NavigationView {
                    Text("Content View")
                        .navigationTitle("Title")
                }
            }
    }

    func testShortScrollview() async throws {
        await SwiftUIMatcher()
            .sizing(.dynamicHeight)
            .match {
                ItemList(count: 3)
                    .background(Color(UIColor.systemBackground))
            }
    }

    func testLongScrollview() async throws {
        await SwiftUIMatcher()
            .sizing(.dynamicHeight)
            .match {
                ItemList(count: 25)
                    .background(Color(UIColor.systemBackground))
            }
    }

    func testLongScrollviewInNavigationView() async throws {
        await SwiftUIMatcher()
            .sizing(.dynamicHeight)
            .match {
                NavigationView {
                    ScrollView {
                        ItemList(count: 25)
                    }
                    .navigationTitle("List of items")
                }
            }
    }

    func testLongScrollviewInTabView() async {
        await SwiftUIMatcher()
            .sizing(.dynamicHeight)
            .match {
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

private struct ItemList: View {
    let count: Int

    var body: some View {
        ScrollView {
            ForEach(0..<count, id: \.self) { index in
                Text("Item #\(index + 1)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colors[index % colors.count].opacity(0.6))
            }
        }
    }

    private let colors: [Color] = [.red, .blue, .green, .yellow, .purple]
}
