import Foundation

public extension SnapshotContext.Key where Value == Bool {
    static var isRecording: Self {
        SnapshotContext.Key(name: "isRecording")
    }
}
