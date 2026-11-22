import SwiftUI
import Testing

extension UIMatcher {
  /// Matches a SwiftUI view to the reference image stored by the ``RecordingStrategy``
  /// - Parameter produce: Closure used to produce a SwiftUI view
  public func match<Value: View>(function: StaticString = #function, sourceLocation: SourceLocation = #_sourceLocation, produce: @escaping Snapshot<Value>.Produce) async {
    do {
      try validate()
    } catch {
      Issue.record("\(error.localizedDescription). Nothing was compared or recorded.", sourceLocation: sourceLocation)
      return
    }

    let permutations = colorSchemes
      .flatMap { colorScheme in
        locales.map { locale in
          (colorScheme, locale)
        }
      }
      .flatMap { colorScheme, locale in
        dynamicTypeSizes.map { size in
          (colorScheme, locale, size)
        }
      }

    for device in devices {
      for (colorScheme, locale, dynamicTypeSize) in permutations {
        await Bundle.withOverrideLocale(locale) {
          await Snapshot(function: function, sourceLocation: sourceLocation) {
            try await produce()
              .deferredEnvironment(\.colorScheme, colorScheme)
              .deferredEnvironment(\.dynamicTypeSize, dynamicTypeSize)
              .deferredEnvironment(\.locale, locale)
          }
          .device(device)
          .recordingNameComponent(add: device.name)
          .recordingNameComponent(add: String(describing: colorScheme))
          .recordingNameComponent(add: String(describing: dynamicTypeSize))
          .recordingNameComponent(add: locale.identifier)
          .ignoresSafeArea(ignore: sizing.ignoresSafeArea)
          .diffSwiftUI(
            sizing: sizing,
            rendering: rendering,
            diffing: diffing,
            recording: recording,
            record: record,
          )
          .match(sourceLocation: sourceLocation)
        }
      }
    }
  }
}
