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
        var nameComponents = context.value(for: .recordingNameComponents) ?? []
        nameComponents.append("a11y")
        context.set(value: nameComponents, for: .recordingNameComponents)

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
                context.cgContext.setFillColor(UIColor.lightGray.cgColor)

                let path = UIBezierPath(rect: node.frame)
                path.fill()
                path.stroke()

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                NSString(string: node.label)
                    .draw(in: node.frame, withAttributes: [
                        .paragraphStyle: paragraphStyle
                    ])
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
}

private func recursiveAccessibility(view: UIView) -> [AccessibilityNode] {
    var nodes: [AccessibilityNode] = []

    let elements = view.accessibilityElements?
        .compactMap { $0 as? NSObject }
        .filter(\.isAccessibilityElement) ?? []

    nodes.append(
        contentsOf: elements.map { element in
            AccessibilityNode(
                frame: element.accessibilityFrame,
                label: element.accessibilityLabel ?? "",
                traits: element.accessibilityTraits
            )
        }
    )

    for subview in view.subviews {
        nodes.append(
            contentsOf: recursiveAccessibility(view: subview)
        )
    }

    return nodes
}

