import UIKit

public extension SizingStrategy where Self == ScreenSizeStrategy {
    static var screen: ScreenSizeStrategy {
        ScreenSizeStrategy()
    }
}

public struct ScreenSizeStrategy: SizingStrategy {
    public func size(viewController: UIViewController) -> CGSize {
        UIScreen.main.bounds.size
    }
}
