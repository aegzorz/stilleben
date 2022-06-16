import Foundation
import UIKit
import SwiftUI

extension Snapshot where Value: View {
    public func render(hosted: Bool) -> Snapshot<UIImage> {
        inHostingController()
            .render(hosted: hosted)
    }
}

extension Snapshot where Value: UIViewController {
    public func render(hosted: Bool) -> Snapshot<UIImage> {
        inKeyWindow()
            .map(\.view)
            .render(hosted: hosted)
    }
}

extension Snapshot where Value: UIView {
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
