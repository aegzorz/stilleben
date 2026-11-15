import UIKit

public extension SizingStrategy where Self == DeviceSizeStrategy {
  /// Sizes snapshots to the screen size of the snapshot's ``Device``
  static var device: DeviceSizeStrategy {
    DeviceSizeStrategy()
  }
}

/// Sizing strategy that sizes the snapshots according to the screen size of the snapshot's ``Device``
public struct DeviceSizeStrategy: SizingStrategy {
  public init() {}

  public func size(viewController: UIViewController, context: SnapshotContext) -> CGSize {
    context.device.size
  }
}
