import SwiftUI
import Testing
@testable import Stilleben

/// Snapshot sizes must match the content exactly, without empty space from safe area insets
@MainActor
@Suite
struct SizingTests {
  @Test
  func dynamicHeightIgnoringSafeArea() async throws {
    let image = try await render(ignoresSafeArea: true)

    #expect(image.size == CGSize(width: 402, height: 50))
  }

  @Test
  func dynamicHeightIncludesDeviceSafeArea() async throws {
    let image = try await render(ignoresSafeArea: false)

    #expect(image.size == CGSize(width: 402, height: 50 + 62 + 34))
  }

  @Test
  func fixedHeight() async throws {
    let image = try await render(ignoresSafeArea: true, sizing: .fixedHeight(80))

    #expect(image.size == CGSize(width: 402, height: 80))
  }

  @Test
  func fullWidth() async throws {
    let image = try await render(ignoresSafeArea: true, sizing: .fullWidth)

    #expect(image.size == CGSize(width: 402, height: 50))
  }

  @Test
  func dynamicHeightMeasuresNavigationControllerWithItsFinalLayout() async throws {
    let snapshot = Snapshot { @MainActor () -> UIViewController in
      // Wrapped like UIMatcher does, to size the same view controller hierarchy
      TraitsViewController(content: UINavigationController(rootViewController: ItemListViewController(count: 12)))
    }
    .device(.iPhone18Pro)
    .ignoresSafeArea(ignore: true)
    .inWindow()
    .size(using: .dynamicHeight)
    _ = try await snapshot.produce()

    let metrics = try #require(snapshot.context.value(for: .sizingMetrics))
    #expect(metrics.safeAreaInsets == .zero)
    #expect(metrics.measuredContentInset != nil)
    #expect(metrics.measuredContentInset == metrics.finalContentInset, "Height measured with stale scroll view insets")
  }

  @Test
  func strategiesChooseWhetherToIgnoreTheSafeArea() {
    let strategies: [(SizingStrategy, Bool)] = [
      (.device, false),
      (.device(ignoresSafeArea: true), true),
      (.dynamicHeight, true),
      (.dynamicHeight(ignoresSafeArea: false), false),
      (.fullWidth, true),
      (.fullWidth(ignoresSafeArea: false), false),
      (.intrinsic, true),
      (.intrinsic(ignoresSafeArea: false), false),
      (.fixedHeight(80), true),
      (.fixedHeight(80, ignoresSafeArea: false), false),
      (CustomSizingStrategy(), true),
    ]
    for (strategy, ignoresSafeArea) in strategies {
      #expect(strategy.ignoresSafeArea == ignoresSafeArea, "\(strategy)")
    }
  }

  @Test
  func strategyThatKeepsTheSafeAreaGetsTheDeviceSafeArea() async throws {
    let sizing: SizingStrategy = .dynamicHeight(ignoresSafeArea: false)
    let snapshot = Snapshot {
      Color.red.frame(height: 50)
    }
    .device(.iPhone18Pro)
    .ignoresSafeArea(ignore: sizing.ignoresSafeArea)
    .inHostingController()
    .inWindow()
    .size(using: sizing)
    _ = try await snapshot.produce()

    let metrics = try #require(snapshot.context.value(for: .sizingMetrics))
    #expect(metrics.safeAreaInsets == UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0))
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

/// A strategy that doesn't say whether it ignores the safe area, like most custom strategies
private struct CustomSizingStrategy: SizingStrategy {
  func size(viewController: UIViewController, context: SnapshotContext) -> CGSize {
    CGSize(width: 100, height: 100)
  }
}
