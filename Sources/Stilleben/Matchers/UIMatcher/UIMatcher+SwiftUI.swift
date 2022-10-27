import SwiftUI

extension UIMatcher {
    /// Matches a SwiftUI view to the reference image stored by the ``RecordingStrategy``
    /// - Parameter produce: Closure used to produce a SwiftUI view
    public func match<Value: View>(file: StaticString = #file, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<Value>.Produce) async {
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
            Bundle.overrideLocale = locale

            await Snapshot(file: file, function: function, line: line) {
                try await produce()
                    .ignoresSafeArea(ignoresSafeArea ? .all : [], edges: ignoresSafeArea ? .all : [])
                    .deferredEnvironment(\.colorScheme, colorScheme)
                    .deferredEnvironment(\.dynamicTypeSize, dynamicTypeSize)
                    .deferredEnvironment(\.locale, locale)
            }
            .assertSimulator(modelIdentifier: assertSimulatorModelIdentifier, file: file, line: line)
            .assertDisplayScale(assertDisplayScale, file: file, line: line)
            .recordingNameComponent(add: String(describing: colorScheme))
            .recordingNameComponent(add: String(describing: dynamicTypeSize))
            .recordingNameComponent(add: locale.identifier)
            .addDeviceName(add: includeDeviceName)
            .ignoresSafeArea(ignore: ignoresSafeArea)
            .diffSwiftUI(
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
}
