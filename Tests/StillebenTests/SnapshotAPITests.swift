import SwiftUI
import Testing
@testable import Stilleben

/// The lower level `Snapshot` API that the matchers are built from
@MainActor
@Suite
struct SnapshotAPITests {
  @Test
  func rendersPlainView() async throws {
    let image = try await Snapshot { @MainActor () -> UIView in
      let view = UIView()
      view.backgroundColor = .red
      return view
    }
    .device(.iPhone18Pro)
    .render(using: .default)
    .produce()

    #expect(image.size == CGSize(width: 402, height: 874))
  }

  @Test
  func diffJson() async {
    struct Model: Encodable {
      let text = "Hello World!"
    }

    await Snapshot { Model() }
      .diffJson()
      .match()
  }

  @Test
  func wrapsInNavigationController() async throws {
    let root = UIViewController()
    let navigationController = try await Snapshot { root }.inNavigationController().produce()

    #expect(navigationController.viewControllers == [root])
  }

  @Test
  func wrapsInTabBarController() async throws {
    let root = UIViewController()
    let tabBarController = try await Snapshot { root }.inTabBarController().produce()

    #expect(tabBarController.viewControllers == [root])
  }
}
