import Testing
import UIKit
@testable import Stilleben

extension SerialTests {
  /// Snapshots that need a window scene, like Liquid Glass bars, so they run hosted in the TestHost app
  @MainActor
  @Suite
  struct HostedUIKitTests {
    private let matcher = UIMatcher()
      .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
      .sizing(.dynamicHeight)
      .colorSchemes(.light)
      .dynamicTypeSizes(.large)

    @Test
    func longScrollviewInTabBarController() async throws {
      await matcher.match { @MainActor () -> UIViewController in
        let controller = UITabBarController()
        controller.viewControllers = [
          UINavigationController(
            // Leaves an item's height of empty space at the end, so the tab bar's glass doesn't render on top of the last item
            rootViewController: ItemListViewController(count: 12, bottomSpacing: true),
          ),
        ]
        return controller
      }
    }
  }
}
