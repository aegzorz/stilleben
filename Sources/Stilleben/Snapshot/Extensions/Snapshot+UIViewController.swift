import UIKit

public extension Snapshot where Value: UIViewController {
    func inKeyWindow() -> Self {
        map { viewController in
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = viewController
            window.makeKeyAndVisible()

            return viewController
        }
    }
}
