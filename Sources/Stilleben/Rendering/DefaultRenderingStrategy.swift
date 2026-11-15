import Foundation
import UIKit

public extension RenderingStrategy where Self == DefaultRenderingStrategy {
  /// Default rendering strategy, draws the view hierarchy at the display scale of the snapshot's ``Device``
  static var `default`: Self {
    DefaultRenderingStrategy()
  }
}

public struct DefaultRenderingStrategy: RenderingStrategy {
  public init() {}

  public func render(viewController: UIViewController, context: SnapshotContext) -> UIImage {
    let format = UIGraphicsImageRendererFormat(for: viewController.traitCollection)
    format.scale = context.device.scale

    let view = viewController.view!
    return UIGraphicsImageRenderer(size: view.bounds.size, format: format).image { _ in
      view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
  }
}
