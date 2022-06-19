import XCTest
import SwiftUI
@testable import Stilleben

final class UIKitTests: XCTestCase {
    func testSimpleLabel() async throws {
        await UIKitMatcher()
            .sizing(.intrinsic)
            .match { @MainActor () -> UIView in
                let label = UILabel()
                label.text = "Hello World!"
                label.backgroundColor = .systemBackground
                return label
            }
    }

    func testNavigation() async throws {
        await Snapshot { @MainActor () -> UIView in
            let label = UILabel()
            label.text = "Content View"
            label.textAlignment = .center
            label.backgroundColor = .systemBackground
            return label
        }
        .asViewController(title: "Title")
        .inNavigationController()
        .diffUIKit()
        .match()
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
