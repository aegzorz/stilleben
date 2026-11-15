import Stilleben
import XCTest

@MainActor
final class RecordModeTests: XCTestCase {
  func testFailedReRecordsMismatch() async {
    let storage = InMemoryRecordingStrategy(reference: Data("old".utf8))
    XCTExpectFailure { $0.compactDescription.contains("re-recorded") }

    await snapshot("new", storage: storage, mode: .failed)

    XCTAssertEqual(storage.reference, Data("new".utf8))
  }

  func testMissingKeepsMismatchingReference() async {
    let storage = InMemoryRecordingStrategy(reference: Data("old".utf8))
    XCTExpectFailure { $0.compactDescription.contains("did not match") }

    await snapshot("new", storage: storage, mode: .missing)

    XCTAssertEqual(storage.reference, Data("old".utf8))
  }

  func testNeverDoesNotRecordMissingReference() async {
    let storage = InMemoryRecordingStrategy(reference: nil)
    XCTExpectFailure { $0.compactDescription.contains("doesn't allow recording") }

    await snapshot("new", storage: storage, mode: .never)

    XCTAssertNil(storage.reference)
  }

  func testAllRecordsMatchingSnapshot() async {
    let storage = InMemoryRecordingStrategy(reference: Data("same".utf8))
    storage.writes = 0
    XCTExpectFailure { $0.compactDescription.contains("record mode is .all") }

    await snapshot("same", storage: storage, mode: .all)

    XCTAssertEqual(storage.writes, 1)
  }

  func testMatchingSnapshotDoesNotRecord() async {
    let storage = InMemoryRecordingStrategy(reference: Data("same".utf8))

    await snapshot("same", storage: storage, mode: .failed)

    XCTAssertEqual(storage.writes, 0)
  }

  private func snapshot(_ text: String, storage: InMemoryRecordingStrategy, mode: RecordMode) async {
    await Snapshot {
      Data(text.utf8)
    }
    .record(using: storage)
    .diff(using: .text)
    .recordMode(mode)
    .match()
  }
}

/// Keeps the reference in memory and counts writes
private final class InMemoryRecordingStrategy: RecordingStrategy {
  var reference: Data?
  var writes = 0

  init(reference: Data?) {
    self.reference = reference
  }

  func read(context: SnapshotContext) async throws -> Data? {
    reference
  }

  func write(data: Data, context: SnapshotContext) async throws {
    reference = data
    writes += 1
  }
}
