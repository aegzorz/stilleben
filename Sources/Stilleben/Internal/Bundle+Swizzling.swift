import Foundation

/// Overrides the language of localized strings while snapshots are taken. Foundation looks strings up through two
/// `Bundle` methods, so both are swizzled:
/// - `localizedString(forKey:value:table:)`, used by `NSLocalizedString` and `Bundle.localizedString`
/// - the private `_localizedStringForKey:value:table:localizations:`, used by `String(localized:)` and
///   `LocalizedStringResource`. It's looked up by name and skipped when it doesn't exist.
///
/// SwiftUI `Text` doesn't use either, it follows the `\.locale` environment that the matchers set.
/// The swizzled methods run on whatever thread asks for a string, so their state is guarded by a lock.
nonisolated extension Bundle {
  private static let localeOverride = LockedValue<(locale: Locale?, swizzled: Bool)>((nil, false))
  private static let localizationsSelector = NSSelectorFromString("_localizedStringForKey:value:table:localizations:")

  static var overrideLocale: Locale? {
    get {
      localeOverride.value.locale
    }
    set {
      let needsSwizzling = localeOverride.withValue { state in
        state.locale = newValue
        defer { state.swizzled = true }
        return !state.swizzled
      }
      if needsSwizzling {
        exchange(#selector(localizedString(forKey:value:table:)), with: #selector(customLocalizedString(forKey:value:table:)))
        exchange(localizationsSelector, with: #selector(customLocalizedString(forKey:value:table:localizations:)))
      }
    }
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
