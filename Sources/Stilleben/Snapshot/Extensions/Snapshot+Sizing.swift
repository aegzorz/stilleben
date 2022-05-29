import Foundation
import UIKit
import SwiftUI

public extension SnapshotContext.Key where Value == CGSize {
    static var targetSize: Self {
        SnapshotContext.Key(name: "targetSize")
    }
}

extension Snapshot where Value: UIViewController {
    public func size(using strategy: SizingStrategy?) -> Snapshot<UIViewController> {
        map { viewController in
            if let strategy = strategy {
                context.set(
                    value: try await strategy.size(viewController: viewController),
                    for: .targetSize
                )
            }
            return viewController
        }
    }
}
