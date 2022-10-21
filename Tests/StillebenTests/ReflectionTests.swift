import XCTest
import Foundation
import Stilleben

final class ReflectionTests: XCTestCase {
    let matcher = ReflectionMatcher()

    func testSimpleModel() async {
        struct Model {
            let text = "Hello World!"
        }

        await matcher.match {
            Model()
        }
    }

    func testComplexModel() async {
        struct Car<T> {
            let manufacturer: Manufacturer
            let model: String
            let modelYear: Int
            let horsePower: Int
            let type: CarType
            let features: [Feature]
            let extra: T
            let referenceDate: Date

            struct Manufacturer {
                let name: String
                let country: String
                let foundedYear: Int
            }

            enum CarType {
                case petrol
                case diesel
                case pluginHybrid
                case electric
            }

            enum Feature {
                case carplay
                case airbag
                case sunroof
            }
        }

        await matcher.match {
            Car(
                manufacturer: .init(name: "Volvo", country: "Sweden", foundedYear: 1927),
                model: "C40",
                modelYear: 2022,
                horsePower: 408,
                type: .electric,
                features: [.carplay, .airbag],
                extra: 1234.5678,
                referenceDate: Date(timeIntervalSinceReferenceDate: 0)
            )
        }
    }
}
