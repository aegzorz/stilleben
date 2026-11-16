import UIKit
import XCTest
@testable import Stilleben

/// Snapshots that need a window scene, like Liquid Glass bars, so they run hosted in the TestHost app
@MainActor
final class HostedUIKitTests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)

  func testLongScrollviewInTabBarController() async throws {
    await matcher.match { @MainActor () -> UIViewController in
      let controller = UITabBarController()
      controller.viewControllers = [
        UINavigationController(
          rootViewController: ItemListViewController(count: 25),
        ),
      ]
      return controller
    }
  }
}
