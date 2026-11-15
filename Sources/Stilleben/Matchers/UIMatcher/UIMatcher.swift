import SwiftUI

/// Snapshot matcher for UI snapshots
public struct UIMatcher: Sendable {
  /// The strategy to use when determining the size of the resulting snapshot
  public var sizing: SizingStrategy = .device
  /// The strategy to use when rendering the view
  public var rendering: RenderingStrategy = .default
  /// The strategy to use when recording and reading reference snapshots
  public var recording: RecordingStrategy = .localFile
  /// The strategy to use when performing image diffs for the snapshots
  public var diffing: ImageDiffingStrategy = .labDelta
  /// When reference recordings are written, ``RecordMode/default`` (`.failed`) unless set
  public var record: RecordMode = .default
  /// Color schemes to permute when taking snapshots
  public var colorSchemes: [ColorScheme] = [.light, .dark]
  /// Dynamic type sizes to permute when taking snapshots
  public var dynamicTypeSizes: [DynamicTypeSize] = [.large, .accessibility5]
  /// Locales to permute when taking snapshots
  public var locales: [Locale] = [Locale(identifier: "en-US")]
  /// The device that snapshots are laid out and rendered for
  public var device: Device = .iPhone17
  /// Include the device name when naming the snapshot
  public var includeDeviceName = false
  /// Ignores safe area while sizing if set to `true`
  public var ignoresSafeArea = false

  public init() {}
}

extension UIMatcher {
  public func sizing(_ value: SizingStrategy) -> Self {
    Modifier(base: self).sizing(value)
  }

  public func rendering(_ value: RenderingStrategy) -> Self {
    Modifier(base: self).rendering(value)
  }

  public func recording(_ value: RecordingStrategy) -> Self {
    Modifier(base: self).recording(value)
  }

  public func diffing(_ value: ImageDiffingStrategy) -> Self {
    Modifier(base: self).diffing(value)
  }

  public func record(_ value: RecordMode) -> Self {
    Modifier(base: self).record(value)
  }

  public func colorSchemes(_ value: ColorScheme...) -> Self {
    Modifier(base: self).colorSchemes(value)
  }

  public func dynamicTypeSizes(_ value: DynamicTypeSize...) -> Self {
    Modifier(base: self).dynamicTypeSizes(value)
  }

  public func locales(_ value: Locale...) -> Self {
    Modifier(base: self).locales(value)
  }

  public func includeDeviceName(_ include: Bool = true) -> Self {
    Modifier(base: self).includeDeviceName(include)
  }

  public func device(_ value: Device) -> Self {
    Modifier(base: self).device(value)
  }

  public func ignoresSafeArea(_ ignore: Bool = true) -> Self {
    Modifier(base: self).ignoresSafeArea(ignore)
  }
}
