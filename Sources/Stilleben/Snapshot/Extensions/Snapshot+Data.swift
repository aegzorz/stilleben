import Foundation
import XCTest

public extension Snapshot where Value == Data {
    struct MissingReferenceError: Error {
        let localizedDescription = "No recording found"
    }

    func record(using strategy: RecordingStrategy) -> Snapshot<(Data, Data)> {
        map { actual in
            if let expected = try await strategy.read(context: context) {
                return (actual, expected)
            } else {
                try await strategy.write(data: actual, context: context)
                XCTFail("No recording found")
                throw MissingReferenceError()
            }
        }
    }
}
