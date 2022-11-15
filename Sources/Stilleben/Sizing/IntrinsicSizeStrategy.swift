import UIKit

public extension SizingStrategy where Self == IntrinsicSizeStrategy {
    static var intrinsic: IntrinsicSizeStrategy {
        IntrinsicSizeStrategy()
    }
}

/// Sizing strategy that sizes the snapshots according to the intrinsic size of the supplied view controller
public struct IntrinsicSizeStrategy: SizingStrategy {
    public func size(viewController: UIViewController, context: SnapshotContext) -> CGSize {
        let insets = viewController.view.safeAreaInsets
        viewController.additionalSafeAreaInsets = UIEdgeInsets(top: -insets.top, left: 0, bottom: -insets.bottom, right: 0)

        var size = viewController.view.intrinsicContentSize
        size.height -= insets.top + insets.bottom

        // If size is not useful, try system sizing
        if size.height <= 0 || size.width <= 0 {
            return viewController.view.systemLayoutSizeFitting(.zero)
        }
        return size
    }
}
