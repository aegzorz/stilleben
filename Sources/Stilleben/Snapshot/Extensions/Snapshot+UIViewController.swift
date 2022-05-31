import UIKit

public extension Snapshot where Value: UIViewController {
    func inKeyWindow() -> Self {
        map { viewController in
            var frame = UIScreen.main.bounds

            if let targetSize = context.value(for: .targetSize) {
                frame = CGRect(origin: .zero, size: targetSize)
            }

            let window = UIWindow(frame: frame)
            window.rootViewController = viewController
            window.makeKeyAndVisible()

            window.setNeedsLayout()
            window.layoutIfNeeded()

            return viewController
        }
    }

    func inNavigationController() -> Snapshot<UINavigationController> {
        map { viewController in
            UINavigationController(rootViewController: viewController)
        }
    }
}
