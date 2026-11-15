import Foundation

extension SnapshotContext.Key where Value == RecordMode {
  public static var recordMode: Self {
    SnapshotContext.Key(name: "recordMode")
  }
}

extension SnapshotContext.Key where Value == Data {
  /// The recording produced by the test, kept so a failed match can re-record it
  static var actualRecording: Self {
    SnapshotContext.Key(name: "actualRecording")
  }
}

extension SnapshotContext.Key where Value == RecordingStrategy {
  static var recordingStrategy: Self {
    SnapshotContext.Key(name: "recordingStrategy")
  }
}

extension SnapshotContext.Key where Value == String {
  public static var fileExtension: Self {
    SnapshotContext.Key(name: "fileExtension")
  }
}

extension SnapshotContext.Key where Value == [String] {
  public static var recordingNameComponents: Self {
    SnapshotContext.Key(name: "recordingNameComponents")
  }
}
