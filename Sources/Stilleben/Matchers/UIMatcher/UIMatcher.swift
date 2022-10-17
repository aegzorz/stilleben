import SwiftUI

/// Snapshot matcher for UI snapshots
public struct UIMatcher {
    /// Indicates whether the tests are running in an app (hosted) or is simply a unit test (not hosted)
    public var hosted = false
    /// The strategy to use when determining the size of the resulting snapshot
    public var sizing: SizingStrategy = .screen
    /// The strategy to use when recording and reading reference snapshots
    public var recording: RecordingStrategy = .localFile
    /// The strategy to use when performing image diffs for the snapshots
    public var diffing: ImageDiffingStrategy = .labDelta
    /// When `true` forces the ``RecordingStrategy`` to record a new snapshot reference.
    public var forceRecording = false
    /// Color schemes to permute when taking snapshots
    public var colorSchemes: [ColorScheme] = [.light, .dark]
    /// Dynamic type sizes to permute when taking snapshots
    public var dynamicTypeSizes: [DynamicTypeSize] = [.large, .accessibility5]
    /// Locales to permute when taking snapshots
    public var locales: [Locale] = [Locale(identifier: "en-US")]
    /// Model identifier for the simulator that the snapshots should be taken on
    public var assertSimulatorModelIdentifier: String?
    /// Display scale for the simulator that the snapshots should be taken on
    public var assertDisplayScale: CGFloat?
    /// Include the device name when naming the snapshot
    public var includeDeviceName = false
    /// Ignores safe area while sizing if set to `true`
    public var ignoresSafeArea = false

    public init() { }
}

extension UIMatcher {
    public func hosted(_ value: Bool) -> Self {
        Modifier(base: self).hosted(value)
    }
    public func sizing(_ value: SizingStrategy) -> Self {
        Modifier(base: self).sizing(value)
    }
    public func recording(_ value: RecordingStrategy) -> Self {
        Modifier(base: self).recording(value)
    }
    public func diffing(_ value: ImageDiffingStrategy) -> Self {
        Modifier(base: self).diffing(value)
    }
    public func forceRecording(_ value: Bool) -> Self {
        Modifier(base: self).forceRecording(value)
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
    public func assertSimulator(modelIdentifier expected: String) -> Self {
        Modifier(base: self).assertSimulatorModelIdentifier(expected)
    }
    public func assertDisplayScale(_ expected: CGFloat) -> Self {
        Modifier(base: self).assertDisplayScale(expected)
    }
    public func ignoresSafeArea(_ ignore: Bool = true) -> Self {
        Modifier(base: self).ignoresSafeArea(ignore)
    }
}
