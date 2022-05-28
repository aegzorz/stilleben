import Foundation
import UIKit
import SwiftUI

extension Snapshot where Value: View {
    public func renderInHostApp() -> Snapshot<UIImage> {
        inHostingController()
            .renderInHostApp()
    }

    public func render() -> Snapshot<UIImage> {
        inHostingController()
            .render()
    }
}

extension Snapshot where Value: UIViewController {
    public func renderInHostApp() -> Snapshot<UIImage> {
        inKeyWindow()
            .map(\.view)
            .renderInHostApp()
    }

    public func render() -> Snapshot<UIImage> {
        inKeyWindow()
            .map(\.view)
            .render()
    }
}

extension Snapshot where Value: UIView {
    public func renderInHostApp() -> Snapshot<UIImage> {
        render(hosted: true)
    }

    public func render() -> Snapshot<UIImage> {
        render(hosted: false)
    }

    func render(hosted: Bool) -> Snapshot<UIImage> {
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
