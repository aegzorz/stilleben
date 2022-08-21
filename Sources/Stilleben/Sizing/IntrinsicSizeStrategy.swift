import UIKit

public extension SizingStrategy where Self == IntrinsicSizeStrategy {
    static var intrinsic: IntrinsicSizeStrategy {
        IntrinsicSizeStrategy()
    }
}

/// Sizing strategy that sizes the snapshots according to the intrinsic size of the supplied view controller
public struct IntrinsicSizeStrategy: SizingStrategy {
    public func size(viewController: UIViewController) -> CGSize {
        let size = viewController.view.intrinsicContentSize
        // If size is not useful, try system sizing
        if size.height <= 0 || size.width <= 0 {
            return viewController.view.systemLayoutSizeFitting(.zero)
        }
        return size
    }
}
