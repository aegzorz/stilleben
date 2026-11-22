import Foundation

/// Overrides the language of localized strings while snapshots are taken. Foundation looks strings up through two
/// `Bundle` methods, so both are swizzled:
/// - `localizedString(forKey:value:table:)`, used by `NSLocalizedString` and `Bundle.localizedString`
/// - the private `_localizedStringForKey:value:table:localizations:`, used by `String(localized:)` and
///   `LocalizedStringResource`. It's looked up by name and skipped when it doesn't exist.
///
/// SwiftUI `Text` doesn't use either, it follows the `\.locale` environment that the matchers set.
///
/// The locale is a task-local value, so it only applies to lookups made by the snapshot that set it, and to tasks it
/// starts. Tests running in parallel each see their own locale, and lookups outside a snapshot aren't changed.
nonisolated extension Bundle {
  /// The locale whose language strings are looked up in, while a snapshot is taken
  @TaskLocal static var overrideLocale: Locale?

  /// Exchanges the lookup methods the first time it's read
  private static let swizzle: Void = {
    exchange(#selector(localizedString(forKey:value:table:)), with: #selector(customLocalizedString(forKey:value:table:)))
    exchange(localizationsSelector, with: #selector(customLocalizedString(forKey:value:table:localizations:)))
  }()

  private static let localizationsSelector = NSSelectorFromString("_localizedStringForKey:value:table:localizations:")

  /// Runs `operation` with strings looked up in the language of `locale`
  nonisolated(nonsending) static func withOverrideLocale<Result>(
    _ locale: Locale,
    operation: nonisolated(nonsending) () async throws -> Result,
  ) async rethrows -> Result {
    swizzle
    return try await $overrideLocale.withValue(locale, operation: operation)
  }

  /// Language code of the overriding locale when this bundle is localized in it
  private var overrideLanguageCode: String? {
    guard let languageCode = Bundle.overrideLocale?.language.languageCode?.identifier,
          localizations.contains(languageCode)
    else { return nil }
    return languageCode
  }

  private static func exchange(_ originalSelector: Selector, with customSelector: Selector) {
    guard let originalMethod = class_getInstanceMethod(self, originalSelector),
          let customMethod = class_getInstanceMethod(self, customSelector)
    else { return }

    if class_addMethod(self, originalSelector, method_getImplementation(customMethod), method_getTypeEncoding(customMethod)) {
      class_replaceMethod(self, customSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
      method_exchangeImplementations(originalMethod, customMethod)
    }
  }

  @objc private func customLocalizedString(forKey key: String, value: String?, table: String?) -> String {
    let bundle = overrideLanguageCode
      .flatMap { languageCode in path(forResource: languageCode, ofType: "lproj") }
      .flatMap(Bundle.init(path:))

    if let bundle {
      return bundle.customLocalizedString(forKey: key, value: value, table: table)
    } else {
      return customLocalizedString(forKey: key, value: value, table: table)
    }
  }

  /// Without explicit localizations the private method falls back to the device language, so pass the overriding one
  @objc private func customLocalizedString(forKey key: String, value: String?, table: String?, localizations: NSArray?) -> String {
    if localizations?.count ?? 0 == 0, let languageCode = overrideLanguageCode {
      return customLocalizedString(forKey: key, value: value, table: table, localizations: [languageCode] as NSArray)
    }
    return customLocalizedString(forKey: key, value: value, table: table, localizations: localizations)
  }
}
