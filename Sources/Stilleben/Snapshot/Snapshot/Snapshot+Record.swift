import Foundation
import XCTest
import SwiftUI

public extension Snapshot where Value == Data {
    /// Error used when the recording strategy can't find a reference to compare to
    struct MissingReferenceError: LocalizedError {
        public var errorDescription: String? = "No recording for snapshot was found. Re-run to compare against recorded snapshot."
    }

    /// Records a snapshot if no reference could be found
    /// - Parameter using: Recoding strategy
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
    /// Forces recording of a new snapshot
    /// - Parameter force: Whether or not to force a new recording
    func forceRecording(file: StaticString = #file, line: UInt = #line, force: Bool = true) -> Self {
        if force {
            XCTFail("Forced recording enabled", file: file, line: line)
        }
        context.set(value: force, for: .isRecording)
        return self
    }

    /// Adds an arbitrary recording name component
    /// - Parameter add: The name component to add
    func recordingNameComponent(add component: String) -> Self {
        context.append(value: component, for: .recordingNameComponents)
        return self
    }

    /// Adds a name component based on the supplied color scheme
    func recordingNameComponent(add colorScheme: ColorScheme) -> Self {
        recordingNameComponent(add: String(describing: colorScheme))
    }

    /// Adds a name component based on the supplied dynamic type
    func recordingNameComponent(add dynamicTypeSize: DynamicTypeSize) -> Self {
        recordingNameComponent(add: String(describing: dynamicTypeSize))
    }

    /// Adds a name component based on the supplied locale
    func recordingNameComponent(add locale: Locale) -> Self {
        recordingNameComponent(add: locale.identifier)
    }
}
