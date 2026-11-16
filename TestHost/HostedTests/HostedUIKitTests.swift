import UIKit
import XCTest
@testable import Stilleben

/// Snapshots that need a window scene, like Liquid Glass bars, so they run hosted in the TestHost app
@MainActor
final class HostedUIKitTests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)

  func testLongScrollviewInTabBarController() async throws {
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
