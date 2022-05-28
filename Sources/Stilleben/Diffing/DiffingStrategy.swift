import Foundation
import XCTest

public protocol DiffingStrategy {
    associatedtype Value

    func diff(actual: Value, expected: Value) async throws -> Diff
}

public enum Diff {
    case same
    case different(description: String, attachments: [XCTAttachment])
}

public extension Snapshot {
    func diff<T: DiffingStrategy>(using strategy: T) -> Snapshot<Diff> where Value == (T.Value, T.Value) {
        map { (actual, expected) in
            try await strategy.diff(actual: actual, expected: expected)
        }
    }
}
