import UIKit

extension UIMatcher {
    /// Matches a UIViewController to the reference image stored by the ``RecordingStrategy``
    /// - Parameter produce: Closure used to produce a `UIViewController`
    public func match<Value: UIViewController>(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<Value>.Produce) async {
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
            .assertSimulator(modelIdentifier: assertSimulatorModelIdentifier, file: file, line: line)
            .assertDisplayScale(assertDisplayScale, file: file, line: line)
            .recordingNameComponent(add: colorScheme)
            .recordingNameComponent(add: dynamicTypeSize)
            .recordingNameComponent(add: locale)
            .addDeviceName(add: includeDeviceName)
            .ignoresSafeArea(ignore: ignoresSafeArea)
            .diffUIKit(
                file: file,
                line: line,
                sizing: sizing,
                rendering: rendering,
                diffing: diffing,
                recording: recording,
                forceRecording: forceRecording
            )
            .match(file: file, line: line)
        }
    }

    /// Matches a UIView to the reference image stored by the ``RecordingStrategy``
    /// - Parameter produce: Closure used to produce a `UIView`
    public func match(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<UIView>.Produce) async {
        await match(file: file, function: function, line: line) { @MainActor () -> UIViewController in
            WrapperViewController(
                view: try await produce()
            )
        }
    }
}
