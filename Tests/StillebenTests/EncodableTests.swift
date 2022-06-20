import XCTest
import Foundation
import Stilleben

final class EncodableTests: XCTestCase {
    func testSimpleEncodable() async {
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

    func testNonTrivialEncodable() async {
        struct Person: Encodable {
            let firstName: String
            let middleName: String?
            let lastName: String

            let birthdate: Date

            let info: [String: String]
        }

        await Snapshot {
            Person(
                firstName: "John",
                middleName: nil,
                lastName: "Appleseed",
                birthdate: Date(timeIntervalSince1970: 197208000),
                info: [
                    "Hobbies": "iOS Development"
                ]
            )
        }
        .encodeJson { encoder in
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
        }
        .record(using: .localFile)
        .diff(using: .text)
        .match()
    }
}
