import Foundation
import UIKit

public extension RenderingStrategy where Self == DefaultRenderingStrategy {
    /// Default rendering strategy, renders the view controller to a `UIImage`
    /// - Parameter hosted: Indicates whether the tests are running in an app (hosted) or is simply a unit test (not hosted)
    static func `default`(hosted: Bool) -> Self {
        DefaultRenderingStrategy(hosted: hosted)
    }
}

public struct DefaultRenderingStrategy: RenderingStrategy {
    let hosted: Bool

    public func render(viewController: UIViewController, context: SnapshotContext) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: viewController.view.frame.size)
        let image = renderer.image { context in
            if hosted {
                viewController.view.drawHierarchy(in: viewController.view.bounds, afterScreenUpdates: true)
            } else {
                viewController.view.layer.render(in: context.cgContext)
            }
        }
        return image
    }
}

