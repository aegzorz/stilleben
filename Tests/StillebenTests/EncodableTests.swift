import XCTest
import Foundation
import Stilleben

final class EncodableTests: XCTestCase {
    func testSimpleEncodable() async throws {
        struct Model: Encodable {
            let text = "Hello World!"
        }

        await Snapshot {
            Model()
        }
        .encodeJson()
        .record(using: .localFile)
        .diff(using: .text)
        .match()
    }
}
