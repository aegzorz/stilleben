import UIKit

public extension Snapshot where Value: UIViewController {
  /// Places the `UIViewController` in a window of the configured ``Device``. Tests hosted in an app use a window in
  /// the app's window scene; tests of Swift packages have no scene and get a standalone window.
  /// The window is released again after rendering.
  func inWindow() -> Self {
    map { viewController in
      try attachToWindow(viewController)
      return viewController
    }
  }

  /// Wraps the `UIViewController` in a `UINavigationController`
  func inNavigationController() -> Snapshot<UINavigationController> {
    map { viewController in
      UINavigationController(rootViewController: viewController)
    }
  }

  /// Wraps the `UIViewController` in a `UITabBarController`
  func inTabBarController() -> Snapshot<UITabBarController> {
    map { viewController in
      let controller = UITabBarController()
      controller.viewControllers = [viewController]
      return controller
    }
  }
}

extension Snapshot {
  func attachToWindow(_ viewController: UIViewController) throws {
    guard viewController.view.window == nil else { return }

    let device = try context.device
    let scene = UIApplication.shared.connectedScenes.lazy.compactMap { $0 as? UIWindowScene }.first

    let window = scene.map(UIWindow.init(windowScene:)) ?? makeWindowWithoutScene()
    window.frame = CGRect(origin: .zero, size: device.size)
    window.traitOverrides.displayScale = device.scale
    window.traitOverrides.userInterfaceIdiom = device.idiom
    window.traitOverrides.horizontalSizeClass = device.horizontalSizeClass
    window.traitOverrides.verticalSizeClass = device.verticalSizeClass
    window.rootViewController = viewController
    window.isHidden = false
    window.layoutIfNeeded()
  }
}

/// Tests of Swift packages run without an app, so there is no window scene. A window created without a scene is
/// still rendered correctly with `CALayer.render(in:)`, but its only initializers are deprecated since iOS 26.
@diagnose(DeprecatedDeclaration, as: ignored)
private func makeWindowWithoutScene() -> UIWindow {
  UIWindow(frame: .zero)
}

extension UIViewController {
  /// Hides the window this view controller was snapshotted in, so the scene releases it
  func detachFromWindow() {
    guard let window = view.window else { return }
    window.isHidden = true
    window.rootViewController = nil
  }
}
