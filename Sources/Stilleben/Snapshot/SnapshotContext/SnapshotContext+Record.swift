import Foundation

extension SnapshotContext.Key where Value == Bool {
    public static var isRecording: Self {
        SnapshotContext.Key(name: "isRecording")
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
