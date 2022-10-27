import Foundation
import UIKit

/// Protocol describing how to size `UIViewController` before taking the snapshot
public protocol SizingStrategy {
    /// Sizing function for the view controller being snapshotted
    /// - Parameter viewController: The `UIViewController` being sized.
    /// - Parameter context: The context of the current snapshot.
    /// - Returns: The `CGSize` to use when snapshotting.
    func size(viewController: UIViewController, context: SnapshotContext) async throws -> CGSize
}
