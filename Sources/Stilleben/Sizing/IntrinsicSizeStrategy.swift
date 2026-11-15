import UIKit

public extension SizingStrategy where Self == IntrinsicSizeStrategy {
  static var intrinsic: IntrinsicSizeStrategy {
    IntrinsicSizeStrategy()
  }
}

/// Sizing strategy that sizes the snapshots according to the intrinsic size of the supplied view controller
public struct IntrinsicSizeStrategy: SizingStrategy {
  public nonisolated init() {}

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    let view = try viewController.view.unwrap()
    let size = view.intrinsicContentSize

    // Views without an intrinsic size are measured by their constraints
    if size.width <= 0 || size.height <= 0 || size.width == UIView.noIntrinsicMetric || size.height == UIView.noIntrinsicMetric {
      return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    return size
  }
}
