import XCTest
import SwiftUI
@testable import Stilleben

final class StillebenTests: XCTestCase {
    func testSwiftUISnapshot() async throws {
        try await Snapshot {
            ScrollView {
                Text("Hello World")
                    .border(Color.red)
            }
        }
        .diffSwiftUI()
        .match()
    }

    func testJsonSnapshot() async throws {
        struct Test: Encodable {
            var title = "Hello World!"
        }

        try await Snapshot {
            Test()
        }
        .diffJson()
        .match()
    }
}
