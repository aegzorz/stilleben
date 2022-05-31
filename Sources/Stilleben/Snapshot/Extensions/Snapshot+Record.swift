import Foundation
import XCTest

public extension SnapshotContext.Key where Value == Bool {
    static var isRecording: Self {
        SnapshotContext.Key(name: "isRecording")
    }
}

public extension Snapshot where Value == Data {
    struct MissingReferenceError: LocalizedError {
        public var errorDescription: String? = "No recording for snapshot was found. Re-run to compare against recorded snapshot."
    }

    func record(using strategy: RecordingStrategy) -> Snapshot<(Data, Data)> {
        map { actual in
            if context.value(for: .isRecording) {
                try await strategy.write(data: actual, context: context)
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

public extension Snapshot {
    func forceRecording(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTFail("Forced recording enabled", file: file, line: line)
        context.set(value: true, for: .isRecording)
        return self
    }
}
