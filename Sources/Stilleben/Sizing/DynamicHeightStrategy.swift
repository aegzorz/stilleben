import UIKit

public extension SizingStrategy where Self == DynamicHeightStrategy {
  static var dynamicHeight: Self {
    DynamicHeightStrategy()
  }
}

/// Sizing strategy that keeps the width of the snapshot's ``Device`` and fits the height to the content,
/// including the full content of vertically scrolling views.
public struct DynamicHeightStrategy: SizingStrategy {
  public init() {}

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    let view = try viewController.view.unwrap()
    let width = context.device.size.width

    if let scrollView = view.findScrollView() {
      view.layoutIfNeeded()
      let insets = scrollView.adjustedContentInset
      let hiddenContent = scrollView.contentSize.height + insets.top + insets.bottom - scrollView.frame.height
      return CGSize(width: width, height: view.bounds.height + hiddenContent)
    }

    let fitting = view.systemLayoutSizeFitting(
      CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel,
    )
    return CGSize(width: width, height: fitting.height > 0 ? fitting.height : view.bounds.height)
  }
}
