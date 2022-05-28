import Foundation

extension RecordingStrategy where Self == LocalFileRecordingStrategy {
    public static func localFile(fileExtension: String) -> LocalFileRecordingStrategy {
        LocalFileRecordingStrategy(fileExtension: fileExtension)
    }
}

public struct LocalFileRecordingStrategy: RecordingStrategy {
    public let fileExtension: String

    public func read(context: SnapshotContext) async throws -> Data? {
        let artifact = artifactUrl(context: context)
        guard fileManager.fileExists(atPath: artifact.path) else {
            return nil
        }
        let data = try Data(contentsOf: artifact)
        return data
    }

    public func write(data: Data, context: SnapshotContext) async throws {
        if !fileManager.fileExists(atPath: context.recordingDirectory.path) {
            try fileManager.createDirectory(at: context.recordingDirectory, withIntermediateDirectories: true)
        }

        try data.write(to: artifactUrl(context: context))
    }

    // MARK: - Private
    private let fileManager = FileManager()

    private func artifactUrl(context: SnapshotContext) -> URL {
        context.recordingDirectory.appendingPathComponent(
            context.baseName
        )
        .appendingPathExtension(fileExtension)
    }
}

private extension SnapshotContext {
    var recordingDirectory: URL {
        let folder = callsite.fileUrl.deletingPathExtension().lastPathComponent

        return callsite.fileUrl.deletingLastPathComponent()
            .appendingPathComponent("Snapshots")
            .appendingPathComponent(folder)
    }

    var baseName: String {
        callsite.functionName
            .removingPrefix("test")
            .removingSuffix("()")
            .lowercaseFirstLetter()
    }
}
