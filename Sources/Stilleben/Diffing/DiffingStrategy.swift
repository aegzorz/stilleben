import Foundation
import XCTest


/// Defines how values of the associated type `Value` should be diffed.
public protocol DiffingStrategy {
    associatedtype Value


    /// Calculates the difference `Diff` between the `actual` and `expected` values.
    /// - Parameter actual: Snapshot produced by running a test
    /// - Parameter expected: Reference snapshot, provided by `RecordingStrategy`
    /// - Returns: Diff between the passed in values
    func diff(actual: Value, expected: Value) async throws -> Diff
}

/// Describes the difference between to values.
public enum Diff {
    /// Represents values that are considered to be the same.
    case same
    /// Represents values that are considered to be different.
    /// - Parameter description: Description of difference
    /// - Parameter attachments: Array of `XCTAttachment` which can be seen in the test report.
    case different(description: String, attachments: [XCTAttachment])
}

public extension Snapshot {
    /// Transforms a snapshot containing a tuple into a snapshot representing a `Diff`
    /// - Parameter using: DiffingStrategy to use when diffing.
    func diff<T: DiffingStrategy>(using strategy: T) -> Snapshot<Diff> where Value == (T.Value, T.Value) {
        map { (actual, expected) in
            try await strategy.diff(actual: actual, expected: expected)
        }
    }
}
