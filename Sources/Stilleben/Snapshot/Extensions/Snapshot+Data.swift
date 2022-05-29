import Foundation
import XCTest

public extension Snapshot where Value == Data {
    struct MissingReferenceError: Error {
        let localizedDescription = "No recording found"
    }
    struct RecordingModeEnabled: Error {
        let localizedDescription = "Recording snapshots mode enabled"
    }

    func record(using strategy: RecordingStrategy) -> Snapshot<(Data, Data)> {
        map { actual in
            if isRecordingSnapshots {
                try await strategy.write(data: actual, context: context)
                throw RecordingModeEnabled()
            }

            if let expected = try await strategy.read(context: context) {
                return (actual, expected)
            } else {
                try await strategy.write(data: actual, context: context)
                throw MissingReferenceError()
            }
        }
    }
}
