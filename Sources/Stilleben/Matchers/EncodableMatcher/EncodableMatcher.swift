import Combine
import Foundation

/// Snapshot matcher for Encodable snapshots
public struct EncodableMatcher: Sendable {
  /// The strategy to use when recording and reading reference snapshots
  public var recording: RecordingStrategy = .localFile
  /// The strategy to use when performing text diffs for the snapshots
  public var diffing: TextDiffingStrategy = .text
  /// When reference recordings are written, ``RecordMode/default`` (`.failed`) unless set
  public var record: RecordMode = .default
  /// The encoder used when encoding models in the matcher.
  public var encoder: JSONEncoder = .matcherDefault

  public init() {}
}

extension EncodableMatcher {
  public func match<Value: Encodable>(file: StaticString = #filePath, function: StaticString = #function, line: UInt = #line, produce: @escaping Snapshot<Value>.Produce) async {
    await Snapshot(file: file, function: function, line: line) {
      try await produce()
    }
    .encodeJson(encoder: encoder)
    .record(using: recording)
    .diff(using: diffing)
    .recordMode(record)
    .match(file: file, line: line)
  }
}

extension EncodableMatcher {
  public func recording(_ value: RecordingStrategy) -> Self {
    Modifier(base: self).recording(value)
  }

  public func diffing(_ value: TextDiffingStrategy) -> Self {
    Modifier(base: self).diffing(value)
  }

  public func record(_ value: RecordMode) -> Self {
    Modifier(base: self).record(value)
  }

  public func encoder(_ value: JSONEncoder) -> Self {
    Modifier(base: self).encoder(value)
  }
}

private extension JSONEncoder {
  static var matcherDefault: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return encoder
  }
}
