import UIKit

public extension SizingStrategy where Self == IntrinsicSizeStrategy {
    static var intrinsic: IntrinsicSizeStrategy {
        IntrinsicSizeStrategy()
    }
}

public struct IntrinsicSizeStrategy: SizingStrategy {
    public func size(viewController: UIViewController) -> CGSize {
        let size = viewController.view.intrinsicContentSize
        if size.height <= 0 || size.width <= 0 {
            return viewController.view.systemLayoutSizeFitting(.zero)
        }
        return size
    }
}
