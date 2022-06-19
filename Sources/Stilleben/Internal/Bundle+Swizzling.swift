import Foundation

extension Bundle {
    static var overrideLocale: Locale? {
        didSet {
            swizzleLocalizationIfNeeded()
        }
    }

    private static var swizzled = false

    private static func swizzleLocalizationIfNeeded() {
        guard !swizzled else { return }
        swizzled = true

        swizzleLocalization()
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
        let bundle = Bundle.overrideLocale.flatMap(\.languageCode)
            .flatMap { languageCode in
                path(forResource: languageCode, ofType: "lproj")
            }
            .flatMap(Bundle.init(path:))

        if let bundle = bundle {
            return bundle.customLocalizedString(forKey: key, value: value, table: table)
        } else {
            return customLocalizedString(forKey: key, value: value, table: table)
        }
    }
}
