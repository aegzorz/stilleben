import Foundation
import SwiftUI

public struct SwiftUIMatcher<Value: View>: SnapshotMatcher {
    public var hosted = false
    public var sizing: SizingStrategy = .screen
    public var recording: RecordingStrategy = .localFile
    public var diffing: ImageDiffingStrategy = .labDelta
    public var forceRecording = false
    public var colorSchemes: [ColorScheme] = [.light, .dark]
    public var dynamicTypeSizes: [DynamicTypeSize] = [.large]
    public var locales: [Locale] = [Locale(identifier: "en-US")]

    public init() { }

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
            .inHostingController()
            .inKeyWindow()
            .size(using: sizing)
            .render(hosted: hosted)
            .record(using: recording)
            .diff(using: diffing)
            .forceRecording(file: file, line: line, force: forceRecording)
            .match(file: file, line: line)
        }
    }
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
}
