import CoreImage
import Testing
import UIKit

/// A value attached to the test report when a ``Diff`` is ``Diff/different(description:attachments:)``.
public struct DiffAttachment {
  enum Content {
    case image(UIImage)
    case ciImage(CIImage)
    case text(String)
  }

  let name: String
  let content: Content

  /// Attaches an image, saved as a PNG
  public static func image(_ image: UIImage, named name: String) -> Self {
    Self(name: name, content: .image(image))
  }

  /// Attaches a Core Image image, rendered and saved as a PNG
  public static func image(_ image: CIImage, named name: String) -> Self {
    Self(name: name, content: .ciImage(image))
  }

  /// Attaches text, saved as a text file
  public static func text(_ text: String, named name: String) -> Self {
    Self(name: name, content: .text(text))
  }

  func record(sourceLocation: SourceLocation) {
    switch content {
    case let .image(image):
      Attachment.record(image, named: name, as: .png, sourceLocation: sourceLocation)
    case let .ciImage(image):
      Attachment.record(image, named: name, as: .png, sourceLocation: sourceLocation)
    case let .text(text):
      Attachment.record(text, named: "\(name).txt", sourceLocation: sourceLocation)
    }
  }
}
