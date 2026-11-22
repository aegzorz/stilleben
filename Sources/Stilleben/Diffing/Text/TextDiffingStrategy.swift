import Foundation
import SwiftUI

extension DiffingStrategy where Self == TextDiffingStrategy {
  public static var text: TextDiffingStrategy {
    TextDiffingStrategy()
  }
}

/// Diffing strategy used for diffing strings.
public struct TextDiffingStrategy: DiffingStrategy {
  public func diff(actual: String, expected: String) async throws -> Diff {
    if actual == expected {
      return .same
    } else {
      return .different(
        description: "Snapshots did not match\nExpected: \(expected)\nActual: \(actual)",
        attachments: [
          .text(actual, named: "Actual"),
          .text(expected, named: "Expected"),
        ],
      )
    }
  }
}

public extension Snapshot where Value == (Data, Data) {
  func diff(using strategy: TextDiffingStrategy) -> Snapshot<Diff> {
    map { actual, expected in
      try (String(data: actual, encoding: .utf8).unwrap(), String(data: expected, encoding: .utf8).unwrap())
    }
    .diff(using: strategy)
  }
}
