import UIKit

public extension SizingStrategy where Self == DeviceSizeStrategy {
  /// Sizes snapshots to the screen size of the snapshot's ``Device``, keeping its safe area
  static var device: DeviceSizeStrategy {
    DeviceSizeStrategy(ignoresSafeArea: false)
  }

  /// Sizes snapshots to the screen size of the snapshot's ``Device``
  /// - Parameter ignoresSafeArea: Whether the snapshot ignores the device's safe area
  static func device(ignoresSafeArea: Bool) -> DeviceSizeStrategy {
    DeviceSizeStrategy(ignoresSafeArea: ignoresSafeArea)
  }
}

/// Sizing strategy that sizes the snapshots according to the screen size of the snapshot's ``Device``
public struct DeviceSizeStrategy: SizingStrategy {
  public let ignoresSafeArea: Bool

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    try context.device.size
  }
}
