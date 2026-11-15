import UIKit

public nonisolated extension SizingStrategy where Self == FullWidthStrategy {
  /// Keeps the width of the snapshot's ``Device`` and fits the height to the content, ignoring scroll views
  static var fullWidth: FullWidthStrategy {
    FullWidthStrategy()
  }
}

/// Sizing strategy that keeps the width of the snapshot's ``Device`` and fits the height to the content.
/// Unlike ``DynamicHeightStrategy`` it doesn't expand scroll views to their full content.
public struct FullWidthStrategy: SizingStrategy {
  public nonisolated init() {}

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    let view = try viewController.view.unwrap()
    let width = context.device.size.width
    let fitting = view.systemLayoutSizeFitting(
      CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel,
    )
    return CGSize(width: width, height: fitting.height)
  }
}
