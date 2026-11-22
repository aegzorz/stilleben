import Testing

extension Issue {
  /// Whether the issue's comments mention `text`, to match known issues
  func mentions(_ text: String) -> Bool {
    comments.contains { $0.rawValue.contains(text) }
  }
}
