import Foundation
import Stilleben
import Testing

extension SerialTests {
  @MainActor
  @Suite
  struct EncodableTests {
    let matcher = EncodableMatcher()

    @Test
    func simpleEncodable() async {
      struct Model: Encodable {
        let text = "Hello World!"
      }

      await matcher.match {
        Model()
      }
    }

    @Test
    func nonTrivialEncodable() async {
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
            birthdate: Date(timeIntervalSince1970: 197_208_000),
            info: [
              "Hobbies": "iOS Development",
            ],
          )
        }
    }
  }
}
