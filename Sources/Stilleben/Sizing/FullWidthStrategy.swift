import UIKit

public extension SizingStrategy where Self == FullWidthStrategy {
  /// Keeps the width of the snapshot's ``Device`` and fits the height to the content, ignoring scroll views
  static var fullWidth: FullWidthStrategy {
    FullWidthStrategy(ignoresSafeArea: true)
  }

  /// Keeps the width of the snapshot's ``Device`` and fits the height to the content, ignoring scroll views
  /// - Parameter ignoresSafeArea: Whether the snapshot ignores the device's safe area
  static func fullWidth(ignoresSafeArea: Bool) -> FullWidthStrategy {
    FullWidthStrategy(ignoresSafeArea: ignoresSafeArea)
  }
}

/// Sizing strategy that keeps the width of the snapshot's ``Device`` and fits the height to the content.
/// Unlike ``DynamicHeightStrategy`` it doesn't expand scroll views to their full content.
public struct FullWidthStrategy: SizingStrategy {
  public let ignoresSafeArea: Bool

  public func size(viewController: UIViewController, context: SnapshotContext) throws -> CGSize {
    let view = try viewController.view.unwrap()
    let width = try context.device.size.width
    let fitting = view.systemLayoutSizeFitting(
      CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel,
    )
    return CGSize(width: width, height: fitting.height)
  }
}
