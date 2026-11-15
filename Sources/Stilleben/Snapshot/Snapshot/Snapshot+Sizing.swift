import Foundation
import SwiftUI
import UIKit

extension Snapshot where Value: UIViewController {
  /// Sizes the snapshots view controller using the supplied strategy
  /// - Parameter using: The strategy to use when sizing the view controller
  public func size(using strategy: SizingStrategy) -> Snapshot<UIViewController> {
    map { viewController in
      try await context.set(
        value: strategy.size(viewController: viewController, context: context),
        for: .targetSize,
      )
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
