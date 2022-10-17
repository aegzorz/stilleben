import Foundation
import UIKit

/// Protocol describing how to render a `UIViewController` into an image.
public protocol RenderingStrategy {
    /// Rendering function for the view controller being snapshotted
    /// - Parameter viewController: The `UIViewController` being rendered.
    /// - Parameter context: The context of the current snapshot.
    /// - Returns: The `UIImage` produced by the rendering strategy.
    func render(viewController: UIViewController, context: SnapshotContext) async throws -> UIImage
}
