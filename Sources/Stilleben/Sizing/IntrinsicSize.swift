import UIKit

public extension SizingStrategy where Self == IntrinsicSizeStrategy {
    static var intrinsic: IntrinsicSizeStrategy {
        IntrinsicSizeStrategy()
    }
}

public struct IntrinsicSizeStrategy: SizingStrategy {
    public func size(viewController: UIViewController) -> CGSize {
        viewController.view.intrinsicContentSize
    }
}
