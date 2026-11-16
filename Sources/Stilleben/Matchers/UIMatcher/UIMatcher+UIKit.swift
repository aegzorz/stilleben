import UIKit
import XCTest

extension UIMatcher {
  /// Matches a UIViewController to the reference image stored by the ``RecordingStrategy``
  /// - Parameter produce: Closure used to produce a `UIViewController`
  public func match<Value: UIViewController>(file: StaticString = #filePath, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<Value>.Produce) async {
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
        await Snapshot(file: file, function: function, line: line) { @MainActor () -> UIViewController in
          Bundle.overrideLocale = locale

          let viewController = try await TraitsViewController(content: produce())
          viewController.interfaceStyle = UIUserInterfaceStyle(colorScheme)
          viewController.contentSizeCategory = UIContentSizeCategory(dynamicTypeSize)

          return viewController
        }
        .device(device)
        .recordingNameComponent(add: device.name)
        .recordingNameComponent(add: colorScheme)
        .recordingNameComponent(add: dynamicTypeSize)
        .recordingNameComponent(add: locale)
        .ignoresSafeArea(ignore: !sizing.includesSafeArea)
        .diffUIKit(
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

  /// Matches a UIView to the reference image stored by the ``RecordingStrategy``
  /// - Parameter produce: Closure used to produce a `UIView`
  public func match(file: StaticString = #filePath, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<UIView>.Produce) async {
    await match(file: file, function: function, line: line) { @MainActor () -> UIViewController in
      try await WrapperViewController(
        view: produce(),
      )
    }
  }
}
