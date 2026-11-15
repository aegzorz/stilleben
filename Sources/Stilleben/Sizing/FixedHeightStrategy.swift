import UIKit

public extension SizingStrategy where Self == FixedHeightStrategy {
  /// Keeps the width of the snapshot's ``Device`` with a fixed height
  static func fixedHeight(_ height: CGFloat) -> FixedHeightStrategy {
    FixedHeightStrategy(height: height)
  }
}

/// Sizing strategy that keeps the width of the snapshot's ``Device`` with a fixed height
public struct FixedHeightStrategy: SizingStrategy {
  let height: CGFloat

  public init(height: CGFloat) {
    self.height = height
  }

  public func size(viewController: UIViewController, context: SnapshotContext) -> CGSize {
    CGSize(width: context.device.size.width, height: height)
  }
}
