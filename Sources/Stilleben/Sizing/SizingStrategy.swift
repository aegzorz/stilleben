import Foundation
import UIKit

/// Protocol describing how to size `UIViewController` before taking the snapshot
public protocol SizingStrategy: Sendable {
  /// Whether snapshots sized by this strategy ignore the device's safe area. `true` unless the strategy says
  /// otherwise; full screen snapshots keep the safe area, like an app does.
  var ignoresSafeArea: Bool { get }

  /// Sizing function for the view controller being snapshotted
  /// - Parameter viewController: The `UIViewController` being sized.
  /// - Parameter context: The context of the current snapshot.
  /// - Returns: The `CGSize` to use when snapshotting.
  func size(viewController: UIViewController, context: SnapshotContext) async throws -> CGSize
}

public extension SizingStrategy {
  var ignoresSafeArea: Bool { true }
}
