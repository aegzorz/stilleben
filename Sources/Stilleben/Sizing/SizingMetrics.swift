import UIKit

/// What sizing measured, recorded in the snapshot's context so tests can verify it
struct SizingMetrics: Equatable {
  /// The scroll view's `adjustedContentInset` when the size was measured
  var measuredContentInset: UIEdgeInsets?
  /// The scroll view's `adjustedContentInset` after the window was resized and the safe area applied
  var finalContentInset: UIEdgeInsets?
  /// The safe area the snapshot's view controller ended up with
  var safeAreaInsets: UIEdgeInsets?
  /// The size the snapshot was given
  var size: CGSize?
}

extension SnapshotContext.Key where Value == SizingMetrics {
  static var sizingMetrics: Self {
    SnapshotContext.Key(name: "sizingMetrics")
  }
}

extension SnapshotContext {
  func updateSizingMetrics(_ update: (inout SizingMetrics) -> Void) {
    var metrics = value(for: .sizingMetrics) ?? SizingMetrics()
    update(&metrics)
    set(value: metrics, for: .sizingMetrics)
  }
}
