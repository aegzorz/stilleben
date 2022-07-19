import Foundation
import UIKit
import SwiftUI

extension Snapshot where Value: UIViewController {
    /// Sizes the snapshots view controller using the supplied strategy
    /// - Parameter using: The strategy to use when sizing the view controller
    public func size(using strategy: SizingStrategy) -> Snapshot<UIViewController> {
        map { viewController in
            context.set(
                value: try await strategy.size(viewController: viewController),
                for: .targetSize
            )
            return viewController
        }
    }
}
