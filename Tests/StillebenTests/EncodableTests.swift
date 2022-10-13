import XCTest
import Foundation
import Stilleben

final class EncodableTests: XCTestCase {
    let matcher = EncodableMatcher()

    func testSimpleEncodable() async {
        struct Model: Encodable {
            let text = "Hello World!"
        }

        await matcher.match {
            Model()
        }
    }

    func testNonTrivialEncodable() async {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        struct Person: Encodable {
            let firstName: String
            let middleName: String?
            let lastName: String

            let birthdate: Date

            let info: [String: String]
        }

        await matcher
            .encoder(encoder)
            .match {
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
    }
}
