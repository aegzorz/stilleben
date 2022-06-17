import Foundation
import XCTest

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
    func forceRecording(file: StaticString = #file, line: UInt = #line, force: Bool = true) -> Self {
        if force {
            XCTFail("Forced recording enabled", file: file, line: line)
        }
        context.set(value: force, for: .isRecording)
        return self
    }

    func recordingNameComponent(add component: String) -> Self {
        var components = context.value(for: .recordingNameComponents) ?? []
        components.append(component)
        context.set(value: components, for: .recordingNameComponents)
        return self
    }
}
