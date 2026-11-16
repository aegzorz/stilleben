import UIKit

public extension SizingStrategy where Self == DeviceSizeStrategy {
  /// Sizes snapshots to the screen size of the snapshot's ``Device``, including its safe area
  static var device: DeviceSizeStrategy {
    DeviceSizeStrategy(includesSafeArea: true)
  }

  /// Sizes snapshots to the screen size of the snapshot's ``Device``
  /// - Parameter includesSafeArea: Whether the snapshot gets the device's safe area
  static func device(includesSafeArea: Bool) -> DeviceSizeStrategy {
    DeviceSizeStrategy(includesSafeArea: includesSafeArea)
  }
}

/// Sizing strategy that sizes the snapshots according to the screen size of the snapshot's ``Device``
public struct DeviceSizeStrategy: SizingStrategy {
  public let includesSafeArea: Bool

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    try context.device.size
  }
}
