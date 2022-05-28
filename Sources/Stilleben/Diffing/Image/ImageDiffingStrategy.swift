import UIKit

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
