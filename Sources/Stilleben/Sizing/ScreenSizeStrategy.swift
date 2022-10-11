import UIKit

public extension SizingStrategy where Self == ScreenSizeStrategy {
    static var screen: ScreenSizeStrategy {
        ScreenSizeStrategy()
    }
}

/// Sizing strategy that sizes the snapshots according to the screen size of the current device.
public struct ScreenSizeStrategy: SizingStrategy {
    public func size(viewController: UIViewController) -> CGSize {
        UIScreen.main.bounds.size
    }
}
