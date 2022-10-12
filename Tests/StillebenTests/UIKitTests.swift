import XCTest
import SwiftUI
@testable import Stilleben

final class UIKitTests: XCTestCase {
    private let matcher = UIMatcher()
        .assertSimulator(modelIdentifier: "iPhone10,4")
        .sizing(.dynamicHeight)
        .forceRecording(false)

    func testSimpleLabel() async throws {
        await matcher
            .sizing(.intrinsic)
            .locales(.english, .swedish)
            .includeDeviceName()
            .match { @MainActor () -> UIView in
                let label = TestLabel()
                label.text = NSLocalizedString("Hello World!", bundle: .module, comment: "")
                label.backgroundColor = .systemBackground
                return label
            }
    }

    func testNavigation() async throws {
        await matcher
            .sizing(.screen)
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
        await matcher.match { @MainActor () -> UIViewController in
            ItemListViewController(count: 3)
        }
    }

    func testLongScrollview() async throws {
        await matcher.match { @MainActor () -> UIViewController in
            ItemListViewController(count: 25)
        }
    }

    func testLongScrollviewInNavigationController() async throws {
        await matcher.match { @MainActor () -> UIViewController in
            UINavigationController(
                rootViewController: ItemListViewController(count: 25)
            )
        }
    }

    func testLongScrollviewInTabBarController() async {
        await matcher.match { @MainActor () -> UIViewController in
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
