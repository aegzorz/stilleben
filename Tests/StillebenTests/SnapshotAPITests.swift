import SwiftUI
import XCTest
@testable import Stilleben

/// The lower level `Snapshot` API that the matchers are built from
@MainActor
final class SnapshotAPITests: XCTestCase {
  func testRendersPlainView() async throws {
    let image = try await Snapshot { @MainActor () -> UIView in
      let view = UIView()
      view.backgroundColor = .red
      return view
    }
    .device(.iPhone18Pro)
    .render(using: .default)
    .produce()

    XCTAssertEqual(image.size, CGSize(width: 402, height: 874))
  }

  func testDiffJson() async {
    struct Model: Encodable {
      let text = "Hello World!"
    }

    await Snapshot { Model() }
      .diffJson()
      .match()
  }

  func testWrapsInNavigationController() async throws {
    let root = UIViewController()
    let navigationController = try await Snapshot { root }.inNavigationController().produce()

    XCTAssertEqual(navigationController.viewControllers, [root])
  }

  func testWrapsInTabBarController() async throws {
    let root = UIViewController()
    let tabBarController = try await Snapshot { root }.inTabBarController().produce()

    XCTAssertEqual(tabBarController.viewControllers, [root])
  }
}
