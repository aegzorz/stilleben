import XCTest
@testable import Stilleben

/// References are written next to the test file, in a folder per test file, and read back from there
@MainActor
final class LocalFileRecordingTests: XCTestCase {
  /// A folder of its own next to this file, removed after each test
  private let folderName = "RecordingTests-\(UUID().uuidString)"

  override func tearDown() async throws {
    let folder = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(folderName)
    try? FileManager.default.removeItem(at: folder)
  }

  func testWritesAndReadsReference() async throws {
    let strategy = LocalFileRecordingStrategy(folderName: folderName)
    let context = context(name: "reference", fileExtension: "txt")

    try await strategy.write(data: Data("Hello".utf8), context: context)
    let data = try await strategy.read(context: context)

    XCTAssertEqual(data, Data("Hello".utf8))
    let file = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
      .appendingPathComponent("\(folderName)/LocalFileRecordingTests/reference.txt")
    XCTAssertTrue(FileManager.default.fileExists(atPath: file.path))
  }

  func testReadsNothingWithoutReference() async throws {
    let data = try await LocalFileRecordingStrategy(folderName: folderName).read(context: context(name: "missing", fileExtension: "txt"))

    XCTAssertNil(data)
  }

  func testMissingFileExtensionThrows() async {
    do {
      _ = try await LocalFileRecordingStrategy(folderName: folderName).read(context: context(name: "reference", fileExtension: nil))
      XCTFail("Expected an error")
    } catch {
      XCTAssertEqual(error as? ConfigurationError, .missingFileExtension)
    }
  }

  func testMissingRecordingNameThrows() async {
    do {
      _ = try await LocalFileRecordingStrategy(folderName: folderName).read(context: context(name: nil, fileExtension: "txt"))
      XCTFail("Expected an error")
    } catch {
      XCTAssertEqual(error as? ConfigurationError, .missingRecordingName)
    }
  }

  private func context(name: String?, fileExtension: String?) -> SnapshotContext {
    let context = SnapshotContext()
    context.set(value: Callsite(file: #filePath, function: #function, line: #line), for: .callsite)
    if let name {
      context.set(value: [name], for: .recordingNameComponents)
    }
    if let fileExtension {
      context.set(value: fileExtension, for: .fileExtension)
    }
    return context
  }
}
