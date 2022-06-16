import Foundation
import UIKit
import SwiftUI

extension Snapshot where Value: UIViewController {
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
