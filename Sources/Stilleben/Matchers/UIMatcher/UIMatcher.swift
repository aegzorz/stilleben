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
  /// Devices to permute when taking snapshots. The device's ``Device/name`` is part of each snapshot's name.
  public var devices: [Device] = [.iPhone18Pro]
  /// Whether snapshots ignore the device's safe area. When `nil`, the sizing strategy decides with
  /// ``SizingStrategy/includesDeviceSafeArea``: full screen `.device` snapshots get the safe area, content sized
  /// snapshots like `.dynamicHeight` or `.intrinsic` don't.
  public var ignoresSafeArea: Bool?
  /// The simulator snapshots have to be taken on. On any other simulator the test fails without comparing or
  /// recording anything, so references aren't overwritten with a different rendering.
  public var simulator: SimulatorRequirement?

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

  public func devices(_ value: Device...) -> Self {
    Modifier(base: self).devices(value)
  }

  public func ignoresSafeArea(_ ignore: Bool = true) -> Self {
    Modifier(base: self).ignoresSafeArea(ignore)
  }

  /// Requires snapshots to be taken on a simulator with this model identifier (like `iPhone19,2`) and iOS version
  /// (matched as a prefix, like `27.2`)
  public func assertSimulator(modelIdentifier: String? = nil, osVersion: String? = nil) -> Self {
    Modifier(base: self).simulator(SimulatorRequirement(modelIdentifier: modelIdentifier, osVersion: osVersion))
  }

  /// Whether snapshots ignore the device's safe area, from ``ignoresSafeArea`` or else the sizing strategy
  var resolvedIgnoresSafeArea: Bool {
    ignoresSafeArea ?? !sizing.includesDeviceSafeArea
  }

  /// Throws a ``ConfigurationError`` when the matcher can't take meaningful snapshots: when a permutation is empty,
  /// or the tests run on another simulator than ``simulator``
  func validate() throws {
    if devices.isEmpty { throw ConfigurationError.emptyPermutation("devices") }
    if colorSchemes.isEmpty { throw ConfigurationError.emptyPermutation("colorSchemes") }
    if dynamicTypeSizes.isEmpty { throw ConfigurationError.emptyPermutation("dynamicTypeSizes") }
    if locales.isEmpty { throw ConfigurationError.emptyPermutation("locales") }
    try simulator?.validate()
  }
}
