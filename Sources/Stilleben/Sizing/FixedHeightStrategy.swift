import UIKit

public extension SizingStrategy where Self == FixedHeightStrategy {
  /// Keeps the width of the snapshot's ``Device`` with a fixed height
  /// - Parameter ignoresSafeArea: Whether the snapshot ignores the device's safe area
  static func fixedHeight(_ height: CGFloat, ignoresSafeArea: Bool = true) -> FixedHeightStrategy {
    FixedHeightStrategy(height: height, ignoresSafeArea: ignoresSafeArea)
  }
}

/// Sizing strategy that keeps the width of the snapshot's ``Device`` with a fixed height
public struct FixedHeightStrategy: SizingStrategy {
  let height: CGFloat
  public let ignoresSafeArea: Bool

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    try CGSize(width: context.device.size.width, height: height)
  }
}
