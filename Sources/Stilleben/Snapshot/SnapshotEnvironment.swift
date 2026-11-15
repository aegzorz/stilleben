import Foundation

/// Values describing the snapshot that is currently being produced, for code that can't read them from the
/// SwiftUI environment. SwiftUI views get the locale through `\.locale`; UIKit code can resolve strings with it:
/// ```
/// label.text = String(localized: LocalizedStringResource("Hello", locale: SnapshotEnvironment.locale, bundle: .main))
/// ```
public enum SnapshotEnvironment {
  /// Locale of the snapshot permutation being produced
  @TaskLocal public static var locale = Locale(identifier: "en-US")
}
