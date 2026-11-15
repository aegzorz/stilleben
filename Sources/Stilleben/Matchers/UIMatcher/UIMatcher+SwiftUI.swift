import SwiftUI
import XCTest

extension UIMatcher {
  /// Matches a SwiftUI view to the reference image stored by the ``RecordingStrategy``
  /// - Parameter produce: Closure used to produce a SwiftUI view
  public func match<Value: View>(file: StaticString = #filePath, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<Value>.Produce) async {
    do {
      try validate()
    } catch {
      return XCTFail("\(error.localizedDescription). Nothing was compared or recorded.", file: file, line: line)
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
        await SnapshotEnvironment.$locale.withValue(locale) {
          await Snapshot(file: file, function: function, line: line) {
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
            file: file,
            line: line,
            sizing: sizing,
            rendering: rendering,
            diffing: diffing,
            recording: recording,
            record: record,
          )
          .match(file: file, line: line)
        }
      }
    }
  }
}
