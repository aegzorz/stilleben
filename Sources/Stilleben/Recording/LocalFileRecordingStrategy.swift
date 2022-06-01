import Foundation

extension RecordingStrategy where Self == LocalFileRecordingStrategy {
    public static var localFile: Self {
        LocalFileRecordingStrategy()
    }
}

extension SnapshotContext.Key where Value == String {
    public static var fileExtension: Self {
        SnapshotContext.Key(name: "fileExtension")
    }
}

public struct LocalFileRecordingStrategy: RecordingStrategy {
    public struct MissingFileExtensionError: LocalizedError {
        public var errorDescription: String? = "Unable to record snapshot, file extension was not set"
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
        if !fileManager.fileExists(atPath: try context.recordingDirectory.path) {
            try fileManager.createDirectory(at: try context.recordingDirectory, withIntermediateDirectories: true)
        }

        try data.write(to: artifactUrl(context: context))
    }

    // MARK: - Private
    private let fileManager = FileManager()

    private func artifactUrl(context: SnapshotContext) throws -> URL {
        let fileExtension = try context.value(for: .fileExtension).unwrap(error: MissingFileExtensionError())

        return try context.recordingDirectory.appendingPathComponent(
            try context.baseName
        )
        .appendingPathExtension(fileExtension)
    }
}

private extension SnapshotContext {
    var recordingDirectory: URL {
        get throws {
            let callsite = try value(for: .callsite).unwrap()
            let folder = callsite.fileUrl.deletingPathExtension().lastPathComponent

            return callsite.fileUrl.deletingLastPathComponent()
                .appendingPathComponent("Snapshots")
                .appendingPathComponent(folder)
        }
    }

    var baseName: String {
        get throws {
            try value(for: .callsite).unwrap()
                .functionName
                .removingPrefix("test")
                .removingSuffix("()")
                .lowercaseFirstLetter()
        }
    }
}
