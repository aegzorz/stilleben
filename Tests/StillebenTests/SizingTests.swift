import Stilleben
import SwiftUI
import XCTest

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

  private func render(ignoresSafeArea: Bool, sizing: SizingStrategy = .dynamicHeight) async throws -> UIImage {
    try await Snapshot {
      Color.red.frame(height: 50)
    }
    .device(.iPhone17)
    .ignoresSafeArea(ignore: ignoresSafeArea)
    .inHostingController()
    .inWindow()
    .size(using: sizing)
    .render(using: .default)
    .produce()
  }
}
