import Foundation
import UIKit

public extension RenderingStrategy where Self == DefaultRenderingStrategy {
  /// Default rendering strategy, renders the view at the display scale of the snapshot's ``Device``
  static var `default`: Self {
    DefaultRenderingStrategy()
  }
}

public struct DefaultRenderingStrategy: RenderingStrategy {
  public func render(viewController: UIViewController, context: SnapshotContext) throws -> UIImage {
    let format = UIGraphicsImageRendererFormat(for: viewController.traitCollection)
    format.scale = try context.device.scale

    let view = try viewController.view.unwrap()
    return UIGraphicsImageRenderer(size: view.bounds.size, format: format).image { rendererContext in
      // Hosted tests (an app with a window scene) use drawHierarchy, which captures everything, Liquid Glass included.
      // Unhosted tests (like Swift package tests) have no app scene, and drawHierarchy would give them an empty image,
      // so render the layer tree instead: same output, except Liquid Glass is missing.
      if let scene = view.window?.windowScene, UIApplication.shared.connectedScenes.contains(scene) {
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
      } else {
        view.layer.render(in: rendererContext.cgContext)
      }
    }
  }
}
