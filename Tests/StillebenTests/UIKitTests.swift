import XCTest
import SwiftUI
@testable import Stilleben

final class UIKitTests: XCTestCase {
    func testSimpleLabel() async throws {
        await UIKitMatcher()
            .sizing(.intrinsic)
            .locales(.english, .swedish)
            .dynamicTypeSizes(.large, .accessibility5)
            .match { @MainActor () -> UIView in
                let label = TestLabel()
                label.text = NSLocalizedString("Hello World!", bundle: .module, comment: "")
                label.backgroundColor = .systemBackground
                return label
            }
    }

    func testNavigation() async throws {
        await UIKitMatcher()
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
        await UIKitMatcher()
            .sizing(.dynamicHeight)
            .match { @MainActor () -> UIViewController in
                ItemListViewController(count: 3)
            }
    }

    func testLongScrollview() async throws {
        await UIKitMatcher()
            .sizing(.dynamicHeight)
            .match { @MainActor () -> UIViewController in
                ItemListViewController(count: 25)
            }
    }

    func testLongScrollviewInNavigationController() async throws {
        await UIKitMatcher()
            .sizing(.dynamicHeight)
            .match { @MainActor () -> UIViewController in
                UINavigationController(
                    rootViewController: ItemListViewController(count: 25)
                )
            }
    }

    func testLongScrollviewInTabBarController() async {
        await UIKitMatcher()
            .sizing(.dynamicHeight)
            .match { @MainActor () -> UIViewController in
                let controller = UITabBarController()
                controller.viewControllers = [
                    UINavigationController(
                        rootViewController: ItemListViewController(count: 25)
                    )
                ]
                return controller
            }
    }
}
