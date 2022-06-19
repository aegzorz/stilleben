import Foundation
import SwiftUI
import UIKit

public struct UIKitMatcher: SnapshotMatcher {
    public typealias Value = UIViewController

    public var hosted = false
    public var sizing: SizingStrategy = .screen
    public var recording: RecordingStrategy = .localFile
    public var diffing: ImageDiffingStrategy = .labDelta
    public var forceRecording = false
    public var colorSchemes: [ColorScheme] = [.light, .dark]
    public var dynamicTypeSizes: [DynamicTypeSize] = [.large, .accessibility5]
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
            await Snapshot(file: file, function: function, line: line) { @MainActor () -> UIViewController in
                Bundle.overrideLocale = locale

                let viewController = TraitsViewController(content: try await produce())
                viewController.interfaceStyle = UIUserInterfaceStyle(colorScheme)
                viewController.contentSizeCategory = UIContentSizeCategory(dynamicTypeSize)

                return viewController
            }
            .recordingNameComponent(add: String(describing: colorScheme))
            .recordingNameComponent(add: String(describing: dynamicTypeSize))
            .recordingNameComponent(add: locale.identifier)
            .addDeviceName(add: includeDeviceName)
            .diffUIKit(
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

    public func match(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<UIView>.Produce) async {
        await match(file: file, function: function, line: line) { @MainActor () -> UIViewController in
            WrapperViewController(
                view: try await produce()
            )
        }
    }

    // MARK: Private
    private var includeDeviceName = false
}

extension UIKitMatcher {
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
