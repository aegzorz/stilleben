import Foundation
import SwiftUI
import UIKit

extension Snapshot where Value: UIViewController {
  /// Sizes the snapshots view controller using the supplied strategy, resizing its window to match
  /// - Parameter using: The strategy to use when sizing the view controller
  public func size(using strategy: SizingStrategy) -> Snapshot<UIViewController> {
    map { viewController in
      try attachToWindow(viewController)

      let size = try await strategy.size(viewController: viewController, context: context)
      context.set(value: size, for: .targetSize)

      if let window = viewController.view.window {
        window.frame = CGRect(origin: .zero, size: size)
        try applySafeArea(to: viewController)
      }
      context.updateSizingMetrics { metrics in
        metrics.size = size
        metrics.safeAreaInsets = viewController.view.safeAreaInsets
        metrics.finalContentInset = viewController.view.findScrollView()?.adjustedContentInset
      }
      return viewController
    }
  }
}

extension Snapshot {
  public func ignoresSafeArea(ignore: Bool) -> Self {
    map { value in
      context.set(value: ignore, for: .ignoresSafeArea)
      return value
    }
  }
}
