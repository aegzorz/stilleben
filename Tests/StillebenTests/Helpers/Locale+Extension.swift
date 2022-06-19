import Foundation

extension Locale: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(identifier: value)
    }
}

extension Locale {
    static let english: Locale = "en-US"
    static let swedish: Locale = "sv-SE"
}
