import Foundation

/// Snapshot matcher for reflected values
public struct ReflectionMatcher: Sendable {
  /// The strategy to use when recording and reading reference snapshots
  public var recording: RecordingStrategy = .localFile
  /// The strategy to use when performing text diffs for the snapshots
  public var diffing: TextDiffingStrategy = .text
  /// When reference recordings are written, ``RecordMode/default`` (`.failed`) unless set
  public var record: RecordMode = .default

  public init() {}
}

extension ReflectionMatcher {
  public func match<Value>(
    file: StaticString = #filePath,
    function: StaticString = #function,
    line: UInt = #line,
    produce: @escaping Snapshot<Value>.Produce,
  )
    async {
    await Snapshot(file: file, function: function, line: line) {
      try await produce()
    }
    .reflect()
    .record(using: recording)
    .diff(using: diffing)
    .recordMode(record)
    .match(file: file, line: line)
  }
}

extension ReflectionMatcher {
  public func recording(_ value: RecordingStrategy) -> Self {
    Modifier(base: self).recording(value)
  }

  public func diffing(_ value: TextDiffingStrategy) -> Self {
    Modifier(base: self).diffing(value)
  }

  public func record(_ value: RecordMode) -> Self {
    Modifier(base: self).record(value)
  }
}
