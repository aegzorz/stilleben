import Foundation
import UIKit
import SwiftUI

extension Snapshot where Value: View {
    /// Renders the snapshots `View` into an `UIImage` using a hosting controller.
    /// - Parameter hosted: Determines if the test is running in an app
    public func render(hosted: Bool) -> Snapshot<UIImage> {
        inHostingController()
            .render(hosted: hosted)
    }
}

extension Snapshot where Value: UIViewController {
    /// Renders the snapshots `UIViewController` into an `UIImage`
    /// - Parameter hosted: Determines if the test is running in an app
    public func render(hosted: Bool) -> Snapshot<UIImage> {
        inKeyWindow()
           .map { viewController in
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
}

extension Snapshot where Value: UIView {
    /// Renders the snapshots `UIView` into an `UIImage`
    /// - Parameter hosted: Determines if the test is running in an app
    public func render(hosted: Bool) -> Snapshot<UIImage> {
        map { view in
            let renderer = UIGraphicsImageRenderer(size: view.frame.size)
            let image = renderer.image { context in
                if hosted {
                    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                } else {
                    view.layer.render(in: context.cgContext)
                }
            }
            return image
        }
    }
}
