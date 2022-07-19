import UIKit

/// Virtual diffing strategy for comparing `UIImage` values.
/// Must be initialized with a closure that actually performs the diffing.
public struct ImageDiffingStrategy: DiffingStrategy {
    public typealias Diffing = (UIImage, UIImage) async throws -> Diff

    let diffing: Diffing

    public init(diffing: @escaping ImageDiffingStrategy.Diffing) {
        self.diffing = diffing
    }

    public func diff(actual: UIImage, expected: UIImage) async throws -> Diff {
        try await diffing(actual, expected)
    }
}
