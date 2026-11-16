import UIKit

public extension SizingStrategy where Self == FixedHeightStrategy {
  /// Keeps the width of the snapshot's ``Device`` with a fixed height
  /// - Parameter includesSafeArea: Whether the snapshot gets the device's safe area
  static func fixedHeight(_ height: CGFloat, includesSafeArea: Bool = false) -> FixedHeightStrategy {
    FixedHeightStrategy(height: height, includesSafeArea: includesSafeArea)
  }
}

/// Sizing strategy that keeps the width of the snapshot's ``Device`` with a fixed height
public struct FixedHeightStrategy: SizingStrategy {
  let height: CGFloat
  public let includesSafeArea: Bool

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    try CGSize(width: context.device.size.width, height: height)
  }
}
