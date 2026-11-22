import Foundation
import Testing
@testable import Stilleben

extension SerialTests {
  /// References are written next to the test file, in a folder per test file, and read back from there
  @MainActor
  @Suite
  final class LocalFileRecordingTests {
    /// A folder of its own next to this file, removed after each test
    private let folderName = "RecordingTests-\(UUID().uuidString)"

    deinit {
      let folder = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(folderName)
      try? FileManager.default.removeItem(at: folder)
    }

    @Test
    func writesAndReadsReference() async throws {
      let strategy = LocalFileRecordingStrategy(folderName: folderName)
      let context = context(name: "reference", fileExtension: "txt")

      try await strategy.write(data: Data("Hello".utf8), context: context)
      let data = try await strategy.read(context: context)

      #expect(data == Data("Hello".utf8))
      let file = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .appendingPathComponent("\(folderName)/LocalFileRecordingTests/reference.txt")
      #expect(FileManager.default.fileExists(atPath: file.path))
    }

    @Test
    func readsNothingWithoutReference() async throws {
      let data = try await LocalFileRecordingStrategy(folderName: folderName).read(context: context(name: "missing", fileExtension: "txt"))

      #expect(data == nil)
    }

    @Test
    func missingFileExtensionThrows() async {
      await #expect(throws: ConfigurationError.missingFileExtension) {
        try await LocalFileRecordingStrategy(folderName: folderName).read(context: context(name: "reference", fileExtension: nil))
      }
    }

    @Test
    func missingRecordingNameThrows() async {
      await #expect(throws: ConfigurationError.missingRecordingName) {
        try await LocalFileRecordingStrategy(folderName: folderName).read(context: context(name: nil, fileExtension: "txt"))
      }
    }

    private func context(name: String?, fileExtension: String?) -> SnapshotContext {
      let context = SnapshotContext()
      context.set(value: Callsite(function: #function, sourceLocation: #_sourceLocation), for: .callsite)
      if let name {
        context.set(value: [name], for: .recordingNameComponents)
      }
      if let fileExtension {
        context.set(value: fileExtension, for: .fileExtension)
      }
      return context
    }
  }
}
