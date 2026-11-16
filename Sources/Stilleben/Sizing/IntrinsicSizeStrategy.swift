import UIKit

public extension SizingStrategy where Self == IntrinsicSizeStrategy {
  /// Sizes snapshots to the intrinsic size of the view controller's view, without the safe area
  static var intrinsic: IntrinsicSizeStrategy {
    IntrinsicSizeStrategy(includesSafeArea: false)
  }

  /// Sizes snapshots to the intrinsic size of the view controller's view
  /// - Parameter includesSafeArea: Whether the snapshot gets the device's safe area
  static func intrinsic(includesSafeArea: Bool) -> IntrinsicSizeStrategy {
    IntrinsicSizeStrategy(includesSafeArea: includesSafeArea)
  }
}

/// Sizing strategy that sizes the snapshots according to the intrinsic size of the supplied view controller
public struct IntrinsicSizeStrategy: SizingStrategy {
  public let includesSafeArea: Bool

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    let view = try viewController.view.unwrap()
    let size = view.intrinsicContentSize

    if size.width <= 0 || size.height <= 0 || size.width == UIView.noIntrinsicMetric || size.height == UIView.noIntrinsicMetric {
      return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    return size
  }
}
