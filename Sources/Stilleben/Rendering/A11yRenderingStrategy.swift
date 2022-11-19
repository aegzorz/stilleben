import Foundation
import UIKit

public extension RenderingStrategy where Self == A11yRenderingStrategy {
    static func a11y(hosted: Bool) -> Self {
        A11yRenderingStrategy(hosted: hosted)
    }
}

public struct A11yRenderingStrategy: RenderingStrategy {
    let hosted: Bool

    public func render(viewController: UIViewController, context: SnapshotContext) -> UIImage {
        context.append(value: "a11y", for: .recordingNameComponents)

        let renderer = UIGraphicsImageRenderer(size: viewController.view.frame.size)
        let image = renderer.image { context in
            if hosted {
                viewController.view.drawHierarchy(in: viewController.view.bounds, afterScreenUpdates: true)
            } else {
                viewController.view.layer.render(in: context.cgContext)
            }

            UIGraphicsPushContext(context.cgContext)

            recursiveAccessibility(view: viewController.view).forEach { node in
                context.cgContext.setStrokeColor(node.color)
                context.cgContext.setFillColor(UIColor.lightGray.withAlphaComponent(0.6).cgColor)

                let path = UIBezierPath(rect: node.frame)
                path.fill()
                path.stroke()

                NSString(string: node.label)
                    .draw(in: node.frame)
            }

            UIGraphicsPopContext()
        }
        return image
    }
}

private struct AccessibilityNode {
    let frame: CGRect
    let label: String
    let traits: UIAccessibilityTraits

    var color: CGColor {
        if traits.contains(.link) {
            return UIColor.blue.cgColor
        } else if traits.contains(.button) {
            return UIColor.green.cgColor
        } else  {
            return UIColor.red.cgColor
        }
    }

    init?(with object: NSObject) {
        guard let label = object.accessibilityLabel else { return nil }

        var frame = object.accessibilityFrame
        if let view = object as? UIView {
            frame = view.convert(view.bounds, to: view.rootView())
        }
        self.frame = frame
        self.label = label
        traits = object.accessibilityTraits
    }
}

private func recursiveAccessibility(view: UIView) -> [AccessibilityNode] {
    var nodes: [AccessibilityNode] = []

    if let node = AccessibilityNode(with: view) {
        nodes.append(node)
    }

    let elements = view.accessibilityElements?
        .compactMap { $0 as? NSObject }
        .filter { $0.accessibilityLabel != nil } ?? []

    nodes.append(contentsOf: elements.compactMap(AccessibilityNode.init))
    nodes.append(contentsOf: view.subviews.flatMap(recursiveAccessibility))

    return nodes
}

private extension UIView {
    func rootView() -> UIView? {
        if let superview {
            return superview.rootView()
        } else {
            return self
        }
    }
}
