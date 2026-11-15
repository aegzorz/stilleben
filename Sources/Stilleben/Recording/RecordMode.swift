import Foundation

/// When snapshots write their reference recordings, like swift-snapshot-testing's record modes.
public enum RecordMode: String, Sendable {
  /// Records every snapshot and fails, to re-record all references
  case all
  /// Records only snapshots that have no reference yet
  case missing
  /// Records missing references and overwrites references that don't match, so changes show up as diffs
  case failed
  /// Never records; missing or different references fail (use on CI)
  case never

  /// `.failed`, unless the `STILLEBEN_RECORD` environment variable names another mode
  public static var `default`: RecordMode {
    ProcessInfo.processInfo.environment["STILLEBEN_RECORD"].flatMap(RecordMode.init(rawValue:)) ?? .failed
  }
}
