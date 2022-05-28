import Foundation
import XCTest
import SwiftUI

extension DiffingStrategy where Self == TextDiffingStrategy {
    public static var text: TextDiffingStrategy {
        TextDiffingStrategy()
    }
}

public struct TextDiffingStrategy: DiffingStrategy {
    public func diff(actual: String, expected: String) async throws -> Diff {
        if actual == expected {
            return .same
        } else {
            return .different(
                description: "Snapshots did not match\nExpected: \(expected)\nActual: \(actual)",
                attachments: [
                    XCTAttachment(string: actual).named("Actual"),
                    XCTAttachment(string: expected).named("Expected")
                ]
            )
        }
    }
}

public extension Snapshot where Value == (Data, Data) {
    func diff(using strategy: TextDiffingStrategy) -> Snapshot<Diff> {
        map { (actual, expected) in
            (try String(data: actual, encoding: .utf8).unwrap(), try String(data: expected, encoding: .utf8).unwrap())
        }
        .diff(using: strategy)
    }
}
