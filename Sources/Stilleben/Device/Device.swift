import UIKit

/// The device a snapshot is rendered for.
///
/// Snapshots are laid out and rendered with the device's size, display scale and traits,
/// so they look the same no matter which simulator runs the tests.
public struct Device: Sendable, Equatable {
  /// Short, stable name of the device class used in snapshot names, like `phone` or `pad`.
  /// It stays the same when a preset moves to a newer model, so snapshots keep their names.
  public var name: String
  /// Screen size in points
  public var size: CGSize
  /// Display scale used when rendering
  public var scale: CGFloat
  /// Safe area insets of the screen, applied unless the snapshot ignores the safe area
  public var safeAreaInsets: UIEdgeInsets
  public var idiom: UIUserInterfaceIdiom
  public var horizontalSizeClass: UIUserInterfaceSizeClass
  public var verticalSizeClass: UIUserInterfaceSizeClass

  public init(
    name: String,
    size: CGSize,
    scale: CGFloat,
    safeAreaInsets: UIEdgeInsets,
    idiom: UIUserInterfaceIdiom,
    horizontalSizeClass: UIUserInterfaceSizeClass,
    verticalSizeClass: UIUserInterfaceSizeClass,
  ) {
    self.name = name
    self.size = size
    self.scale = scale
    self.safeAreaInsets = safeAreaInsets
    self.idiom = idiom
    self.horizontalSizeClass = horizontalSizeClass
    self.verticalSizeClass = verticalSizeClass
  }
}

public extension Device {
  static let iPhone18Pro = Device(
    name: "phone",
    size: CGSize(width: 402, height: 874),
    scale: 3,
    safeAreaInsets: UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0),
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  static let iPhone18ProMax = Device(
    name: "phone-max",
    size: CGSize(width: 440, height: 956),
    scale: 3,
    safeAreaInsets: UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0),
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  static let iPhone17e = Device(
    name: "phone-compact",
    size: CGSize(width: 390, height: 844),
    scale: 3,
    safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  /// iPhone Duo unfolded: a large phone with regular size classes in both directions
  static let iPhoneDuo = Device(
    name: "foldable",
    size: CGSize(width: 669, height: 951),
    scale: 3,
    safeAreaInsets: UIEdgeInsets(top: 82, left: 0, bottom: 34, right: 0),
    idiom: .phone,
    horizontalSizeClass: .regular,
    verticalSizeClass: .regular,
  )

  /// iPhone Duo folded
  static let iPhoneDuoFolded = Device(
    name: "foldable-folded",
    size: CGSize(width: 466, height: 678),
    scale: 3,
    safeAreaInsets: UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 84),
    idiom: .phone,
    horizontalSizeClass: .compact,
    verticalSizeClass: .regular,
  )

  static let iPadPro13 = Device(
    name: "pad",
    size: CGSize(width: 1032, height: 1376),
    scale: 2,
    safeAreaInsets: UIEdgeInsets(top: 32, left: 0, bottom: 20, right: 0),
    idiom: .pad,
    horizontalSizeClass: .regular,
    verticalSizeClass: .regular,
  )
}
