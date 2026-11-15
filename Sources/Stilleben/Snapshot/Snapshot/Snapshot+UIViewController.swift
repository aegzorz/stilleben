import UIKit

/// Thrown when there is no window scene to render snapshots in
public struct MissingWindowSceneError: LocalizedError {
  public var errorDescription: String? {
    "Stilleben renders snapshots in a window, which needs a UIWindowScene. Run the tests hosted in an app (set a test host)."
  }
}

public extension Snapshot where Value: UIViewController {
  /// Places the `UIViewController` in a window of the configured ``Device``, attached to the app's window scene.
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

    let scene = try UIApplication.shared.connectedScenes
      .lazy
      .compactMap { $0 as? UIWindowScene }
      .first
      .unwrap(error: MissingWindowSceneError())
    let device = context.device

    let window = UIWindow(windowScene: scene)
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

extension UIViewController {
  /// Hides the window this view controller was snapshotted in, so the scene releases it
  func detachFromWindow() {
    guard let window = view.window else { return }
    window.isHidden = true
    window.rootViewController = nil
  }
}
