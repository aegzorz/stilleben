import SwiftUI
import Testing
@testable import Stilleben

extension SerialTests {
  @MainActor
  @Suite
  struct UIKitTests {
    private let matcher = UIMatcher()
      .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
      .sizing(.dynamicHeight)
      .colorSchemes(.light)
      .dynamicTypeSizes(.large)

    @Test
    func simpleLabel() async throws {
      await matcher
        .sizing(.intrinsic)
        .locales(.english, .swedish)
        .colorSchemes(.light, .dark)
        .dynamicTypeSizes(.large, .accessibility5)
        .match { @MainActor () -> UIView in
          let label = TestLabel()
          label.text = NSLocalizedString("Hello World!", bundle: .module, comment: "")
          label.backgroundColor = .systemBackground
          return label
        }
    }

    @Test
    func navigation() async throws {
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

    @Test
    func shortScrollview() async throws {
      await matcher
        .match { @MainActor () -> UIViewController in
          ItemListViewController(count: 3)
        }
    }

    @Test
    func longScrollview() async throws {
      await matcher
        .match { @MainActor () -> UIViewController in
          ItemListViewController(count: 12)
        }
    }

    @Test
    func longScrollviewInNavigationController() async throws {
      await matcher.match { @MainActor () -> UIViewController in
        UINavigationController(
          rootViewController: ItemListViewController(count: 12),
        )
      }
    }
  }
}
