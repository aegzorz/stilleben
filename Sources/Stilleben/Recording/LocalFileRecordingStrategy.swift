import Foundation

extension RecordingStrategy where Self == LocalFileRecordingStrategy {
    public static var localFile: Self {
        LocalFileRecordingStrategy(folderName: "Snapshots")
    }
}

/// Recording strategy that stores recorded snapshots locally on disk
public struct LocalFileRecordingStrategy: RecordingStrategy {
    /// Error thrown when no file extension has been set in the `SnapshotContext`
    public struct MissingFileExtensionError: LocalizedError {
        public var errorDescription: String? = "Unable to record snapshot, file extension was not set"
    }

    /// Error thrown when no name components have been set in the `SnapshotContext`
    public struct MissingRecordingNameComponents: LocalizedError {
        public var errorDescription: String? = "Unable to name recording, missing name components"
    }

    /// Initializer for `LocalFileRecordingStrategy`
    /// - Parameter folderName: The name of the folder to store recorded snapshots
    public init(folderName: String) {
        self.folderName = folderName
    }

    public func read(context: SnapshotContext) async throws -> Data? {
        let artifact = try artifactUrl(context: context)
        guard fileManager.fileExists(atPath: artifact.path) else {
            return nil
        }
        let data = try Data(contentsOf: artifact)
        return data
    }

    public func write(data: Data, context: SnapshotContext) async throws {
        let directory = try recordingDirectory(context: context)

        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }

        try data.write(to: artifactUrl(context: context))
    }

    // MARK: - Private
    private let fileManager = FileManager()
    private let folderName: String

    private func artifactUrl(context: SnapshotContext) throws -> URL {
        let fileExtension = try context.value(for: .fileExtension).unwrap(error: MissingFileExtensionError())

        guard let nameComponents = context.value(for: .recordingNameComponents), !nameComponents.isEmpty else {
            throw MissingRecordingNameComponents()
        }

        let recordingName = nameComponents.joined(separator: "-")

        return try recordingDirectory(context: context)
            .appendingPathComponent(recordingName)
            .appendingPathExtension(fileExtension)
    }

    private func recordingDirectory(context: SnapshotContext) throws -> URL {
        let callsite = try context.value(for: .callsite).unwrap()
        let name = callsite.fileUrl.deletingPathExtension().lastPathComponent

        return callsite.fileUrl.deletingLastPathComponent()
            .appendingPathComponent(folderName)
            .appendingPathComponent(name)
    }
}
