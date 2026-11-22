import Testing
import UIKit

extension UIMatcher {
  /// Matches a UIViewController to the reference image stored by the ``RecordingStrategy``
  /// - Parameter produce: Closure used to produce a `UIViewController`
  public func match<Value: UIViewController>(function: StaticString = #function, sourceLocation: SourceLocation = #_sourceLocation, produce: @escaping Snapshot<Value>.Produce) async {
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
        Bundle.overrideLocale = locale
        await Snapshot(function: function, sourceLocation: sourceLocation) { @MainActor () -> UIViewController in
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
        .ignoresSafeArea(ignore: sizing.ignoresSafeArea)
        .diffUIKit(
          sizing: sizing,
          rendering: rendering,
          diffing: diffing,
          recording: recording,
          record: record,
        )
        .match(sourceLocation: sourceLocation)
      }
    }
    Bundle.overrideLocale = nil
  }

  /// Matches a UIView to the reference image stored by the ``RecordingStrategy``
  /// - Parameter produce: Closure used to produce a `UIView`
  public func match(function: StaticString = #function, sourceLocation: SourceLocation = #_sourceLocation, produce: @escaping Snapshot<UIView>.Produce) async {
    await match(function: function, sourceLocation: sourceLocation) { @MainActor () -> UIViewController in
      try await WrapperViewController(
        view: produce(),
      )
    }
  }
}
