import Foundation

/// Overrides the locale used for localized strings by swizzling `Bundle.localizedString(forKey:value:table:)`.
/// The swizzled method runs on whatever thread asks for a string, so its state is guarded by a lock.
nonisolated extension Bundle {
  private static let localeOverride = LockedValue<(locale: Locale?, swizzled: Bool)>((nil, false))

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
        swizzleLocalization()
      }
    }
  }

  private static func swizzleLocalization() {
    let originalSelector = #selector(localizedString(forKey:value:table:))
    guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }

    let mySelector = #selector(customLocalizedString(forKey:value:table:))
    guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

    if class_addMethod(self, originalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
      class_replaceMethod(self, mySelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
      method_exchangeImplementations(originalMethod, myMethod)
    }
  }

  @objc private func customLocalizedString(forKey key: String, value: String?, table: String?) -> String {
    let bundle = Bundle.overrideLocale.flatMap(\.language.languageCode?.identifier)
      .flatMap { languageCode in
        path(forResource: languageCode, ofType: "lproj")
      }
      .flatMap(Bundle.init(path:))

    if let bundle {
      return bundle.customLocalizedString(forKey: key, value: value, table: table)
    } else {
      return customLocalizedString(forKey: key, value: value, table: table)
    }
  }
}
