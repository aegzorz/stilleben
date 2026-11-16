import Foundation
import UIKit

/// Protocol describing how to size `UIViewController` before taking the snapshot
public protocol SizingStrategy: Sendable {
  /// Whether snapshots sized by this strategy get the device's safe area by default, like a full screen app.
  /// `false` unless the strategy says otherwise; overridden with ``UIMatcher/ignoresSafeArea(_:)``.
  var includesDeviceSafeArea: Bool { get }

  /// Sizing function for the view controller being snapshotted
  /// - Parameter viewController: The `UIViewController` being sized.
  /// - Parameter context: The context of the current snapshot.
  /// - Returns: The `CGSize` to use when snapshotting.
  func size(viewController: UIViewController, context: SnapshotContext) async throws -> CGSize
}

public extension SizingStrategy {
  var includesDeviceSafeArea: Bool { false }
}
