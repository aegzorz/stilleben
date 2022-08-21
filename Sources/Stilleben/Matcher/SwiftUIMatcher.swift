import Foundation
import SwiftUI

/// A SnapshotMatcher for SwiftUI views
public struct SwiftUIMatcher<Value: View>: SnapshotMatcher {
    /// Indicates whether the tests are running in an app (hosted) or is simply a unit test (not hosted)
    public var hosted = false
    /// The strategy to use when determining the size of the resulting snapshot
    public var sizing: SizingStrategy = .screen
    /// The strategy to use when recording and reading reference snapshots
    public var recording: RecordingStrategy = .localFile
    /// The strategy to use when performing image diffs for the snapshots
    public var diffing: ImageDiffingStrategy = .labDelta
    /// When `true` forces the `RecordingStrategy` to record a new snapshot reference.
    public var forceRecording = false
    /// Color schemes to permute when taking snapshots
    public var colorSchemes: [ColorScheme] = [.light, .dark]
    /// Dynamic type sizes to permute when taking snapshots
    public var dynamicTypeSizes: [DynamicTypeSize] = [.large, .accessibility5]
    /// Locales to permute when taking snapshots
    public var locales: [Locale] = [Locale(identifier: "en-US")]

    public init() { }

    /// Matches a SwiftUI view to the reference image stored by the `RecordingStrategy`
    /// - Parameter produce: Closure used to produce a SwiftUI view
    public func match(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<Value>.Produce) async {
        let permutations = colorSchemes
            .flatMap { colorScheme in
                locales.map { locale in
                    (colorScheme, locale)
                }
            }
            .flatMap { (colorScheme, locale) in
                dynamicTypeSizes.map { size in
                    (colorScheme, locale, size)
                }
            }

        for (colorScheme, locale, dynamicTypeSize) in permutations {
            await Snapshot(file: file, function: function, line: line) {
                try await produce()
                    .deferredEnvironment(\.colorScheme, colorScheme)
                    .deferredEnvironment(\.dynamicTypeSize, dynamicTypeSize)
                    .deferredEnvironment(\.locale, locale)
            }
            .recordingNameComponent(add: String(describing: colorScheme))
            .recordingNameComponent(add: String(describing: dynamicTypeSize))
            .recordingNameComponent(add: locale.identifier)
            .addDeviceName(add: includeDeviceName)
            .diffSwiftUI(
                file: file,
                line: line,
                sizing: sizing,
                diffing: diffing,
                recording: recording,
                hosted: hosted,
                forceRecording: forceRecording
            )
            .match(file: file, line: line)
        }
    }

    // MARK: Private
    private var includeDeviceName = false
}

extension SwiftUIMatcher {
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
    public func addDeviceName() -> Self {
        Modifier(base: self).includeDeviceName(true)
    }
}
