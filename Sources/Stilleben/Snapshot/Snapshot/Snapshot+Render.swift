import Foundation
import SwiftUI
import UIKit

extension Snapshot where Value: UIViewController {
  /// Renders the snapshots `UIViewController` into an `UIImage`, then releases its window
  /// - Parameter strategy: Render using specific ``RenderingStrategy``
  public func render(using strategy: RenderingStrategy) -> Snapshot<UIImage> {
    map { viewController in
      try attachToWindow(viewController)
      defer { viewController.detachFromWindow() }
      return try await strategy.render(viewController: viewController, context: context)
    }
  }
}

extension Snapshot where Value: UIView {
  /// Renders the snapshots `UIView` into an `UIImage`
  /// - Parameter strategy: Render using specific ``RenderingStrategy``
  public func render(using strategy: RenderingStrategy) -> Snapshot<UIImage> {
    map { view in
      WrapperViewController(view: view)
    }
    .render(using: strategy)
  }
}
