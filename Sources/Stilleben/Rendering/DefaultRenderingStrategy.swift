import Foundation
import UIKit

public extension RenderingStrategy where Self == DefaultRenderingStrategy {
  /// Default rendering strategy, renders the view at the display scale of the snapshot's ``Device``
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
    return UIGraphicsImageRenderer(size: view.bounds.size, format: format).image { rendererContext in
      // Windows without an app scene (tests of Swift packages) get a fallback scene that drawHierarchy renders blank
      if let scene = view.window?.windowScene, UIApplication.shared.connectedScenes.contains(scene) {
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
      } else {
        view.layer.render(in: rendererContext.cgContext)
      }
    }
  }
}
