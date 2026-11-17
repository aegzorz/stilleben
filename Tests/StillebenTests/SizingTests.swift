import SwiftUI
import XCTest
@testable import Stilleben

/// Snapshot sizes must match the content exactly, without empty space from safe area insets
@MainActor
final class SizingTests: XCTestCase {
  func testDynamicHeightIgnoringSafeArea() async throws {
    let image = try await render(ignoresSafeArea: true)

    XCTAssertEqual(image.size, CGSize(width: 402, height: 50))
  }

  func testDynamicHeightIncludesDeviceSafeArea() async throws {
    let image = try await render(ignoresSafeArea: false)

    XCTAssertEqual(image.size, CGSize(width: 402, height: 50 + 62 + 34))
  }

  func testFixedHeight() async throws {
    let image = try await render(ignoresSafeArea: true, sizing: .fixedHeight(80))

    XCTAssertEqual(image.size, CGSize(width: 402, height: 80))
  }

  func testFullWidth() async throws {
    let image = try await render(ignoresSafeArea: true, sizing: .fullWidth)

    XCTAssertEqual(image.size, CGSize(width: 402, height: 50))
  }

  func testDynamicHeightMeasuresNavigationControllerWithItsFinalLayout() async throws {
    let snapshot = Snapshot { @MainActor () -> UIViewController in
      // Wrapped like UIMatcher does, to size the same view controller hierarchy
      TraitsViewController(content: UINavigationController(rootViewController: ItemListViewController(count: 12)))
    }
    .device(.iPhone18Pro)
    .ignoresSafeArea(ignore: true)
    .inWindow()
    .size(using: .dynamicHeight)
    _ = try await snapshot.produce()

    let metrics = try XCTUnwrap(snapshot.context.value(for: .sizingMetrics))
    XCTAssertEqual(metrics.safeAreaInsets, .zero)
    XCTAssertNotNil(metrics.measuredContentInset)
    XCTAssertEqual(metrics.measuredContentInset, metrics.finalContentInset, "Height measured with stale scroll view insets")
  }

  private func render(ignoresSafeArea: Bool, sizing: SizingStrategy = .dynamicHeight) async throws -> UIImage {
    try await Snapshot {
      Color.red.frame(height: 50)
    }
    .device(.iPhone18Pro)
    .ignoresSafeArea(ignore: ignoresSafeArea)
    .inHostingController()
    .inWindow()
    .size(using: sizing)
    .render(using: .default)
    .produce()
  }
}
