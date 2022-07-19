import Foundation
import UIKit

/// Protocol describing how to size `UIViewController` before taking the snapshot
public protocol SizingStrategy {
    /// Sizing function for the view controller being snapshotted
    /// - Parameter viewController: The `UIViewController` being sized.
    /// - Returns: The `CGSize` to use when snapshotting.
    func size(viewController: UIViewController) async throws -> CGSize
}
