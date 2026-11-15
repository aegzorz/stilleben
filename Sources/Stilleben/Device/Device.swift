import UIKit

/// The device a snapshot is rendered for.
///
/// Snapshots are laid out and rendered with the device's size, display scale and traits,
/// so they look the same no matter which simulator runs the tests.
public struct Device: Sendable, Hashable {
  /// Name used in recording names when ``UIMatcher/includeDeviceName(_:)`` is enabled
  public var name: String
  /// Screen size in points
  public var size: CGSize
  /// Display scale used when rendering
  public var scale: CGFloat
  public var idiom: UIUserInterfaceIdiom
  public var horizontalSizeClass: UIUserInterfaceSizeClass
  public var verticalSizeClass: UIUserInterfaceSizeClass

  public nonisolated init(
    name: String,
    size: CGSize,
    scale: CGFloat,
    idiom: UIUserInterfaceIdiom,
    horizontalSizeClass: UIUserInterfaceSizeClass,
    verticalSizeClass: UIUserInterfaceSizeClass,
  ) {
    self.name = name
    self.size = size
    self.scale = scale
    self.idiom = idiom
    self.horizontalSizeClass = horizontalSizeClass
    self.verticalSizeClass = verticalSizeClass
  }
}

public nonisolated extension Device {
  static let iPhone17 = Device(
    name: "iPhone 17",
    size: CGSize(width: 402, height: 874),
    scale: 3,
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  static let iPhone17ProMax = Device(
    name: "iPhone 17 Pro Max",
    size: CGSize(width: 440, height: 956),
    scale: 3,
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  static let iPhone17e = Device(
    name: "iPhone 17e",
    size: CGSize(width: 390, height: 844),
    scale: 3,
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  static let iPadPro13 = Device(
    name: "iPad Pro 13-inch",
    size: CGSize(width: 1032, height: 1376),
    scale: 2,
    idiom: .pad,
    horizontalSizeClass: .regular,
    verticalSizeClass: .regular,
  )

  /// Name usable in file names
  var fileName: String {
    name.replacingOccurrences(of: " ", with: "_")
  }
}
