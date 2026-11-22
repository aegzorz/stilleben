import Testing

/// Snapshots share global state, the window they render in and the language of localized strings, so every suite is
/// nested in this one to run its tests one at a time
@Suite(.serialized)
enum SerialTests {}

extension Issue {
  /// Whether the issue's comments mention `text`, to match known issues
  func mentions(_ text: String) -> Bool {
    comments.contains { $0.rawValue.contains(text) }
  }
}
