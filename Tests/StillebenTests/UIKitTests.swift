import SwiftUI
import XCTest
@testable import Stilleben

@MainActor
final class UIKitTests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)

  func testSimpleLabel() async throws {
    await matcher
      .sizing(.intrinsic)
      .locales(.english, .swedish)
      .match { @MainActor () -> UIView in
        let label = TestLabel()
        label.text = NSLocalizedString("Hello World!", bundle: .module, comment: "")
        label.backgroundColor = .systemBackground
        return label
      }
  }

  func testNavigation() async throws {
    await matcher
      .sizing(.device)
      .match { @MainActor () -> UIViewController in
        let content = TestLabel()
        content.text = "Content View"

        let viewController = WrapperViewController(view: content)
        viewController.title = "Title"

        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
      }
  }

  func testShortScrollview() async throws {
    await matcher
      .ignoresSafeArea()
      .match { @MainActor () -> UIViewController in
        ItemListViewController(count: 3)
      }
  }

  func testLongScrollview() async throws {
    await matcher
      .ignoresSafeArea()
      .match { @MainActor () -> UIViewController in
        ItemListViewController(count: 12)
      }
  }

  func testLongScrollviewInNavigationController() async throws {
    await matcher.match { @MainActor () -> UIViewController in
      UINavigationController(
        rootViewController: ItemListViewController(count: 12),
      )
    }
  }
}
