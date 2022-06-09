import XCTest
import SwiftUI
import Stilleben

final class SwiftUITests: XCTestCase {
    func testSimpleText() async throws {
        await Snapshot {
            Text("Hello World!")
                .padding()
                .background(Color(UIColor.systemBackground))
        }
        .diffSwiftUI(sizing: .intrinsic)
        .match()
    }

    func testNavigation() async throws {
        await Snapshot {
            NavigationView {
                Text("Content View")
                    .navigationTitle("Title")
            }
        }
        .diffSwiftUI()
        .match()
    }

    func testShortScrollview() async throws {
        await Snapshot {
            ScrollView {
                ItemList(count: 3)
            }
            .background(Color(UIColor.systemBackground))
        }
        .diffSwiftUI(sizing: .dynamicHeight)
        .match()
    }

    func testLongScrollview() async throws {
        await Snapshot {
            ItemList(count: 25)
                .background(Color(UIColor.systemBackground))
        }
        .diffSwiftUI(sizing: .dynamicHeight)
        .match()
    }

    func testLongScrollviewInNavigationView() async throws {
        await Snapshot {
            NavigationView {
                ScrollView {
                    ItemList(count: 25)
                }
                .navigationTitle("List of items")
            }
        }
        .diffSwiftUI(sizing: .dynamicHeight)
        .match()
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
