import Foundation
import Stilleben
import Testing

@MainActor
@Suite
struct RecordModeTests {
  @Test
  func failedReRecordsMismatch() async {
    let storage = InMemoryRecordingStrategy(reference: Data("old".utf8))

    await withKnownIssue {
      await snapshot("new", storage: storage, mode: .failed)
    } matching: { issue in
      issue.mentions("re-recorded")
    }

    #expect(storage.reference == Data("new".utf8))
  }

  @Test
  func missingKeepsMismatchingReference() async {
    let storage = InMemoryRecordingStrategy(reference: Data("old".utf8))

    await withKnownIssue {
      await snapshot("new", storage: storage, mode: .missing)
    } matching: { issue in
      issue.mentions("did not match")
    }

    #expect(storage.reference == Data("old".utf8))
  }

  @Test
  func neverDoesNotRecordMissingReference() async {
    let storage = InMemoryRecordingStrategy(reference: nil)

    await withKnownIssue {
      await snapshot("new", storage: storage, mode: .never)
    } matching: { issue in
      issue.mentions("doesn't allow recording")
    }

    #expect(storage.reference == nil)
  }

  @Test
  func allRecordsMatchingSnapshot() async {
    let storage = InMemoryRecordingStrategy(reference: Data("same".utf8))

    await withKnownIssue {
      await snapshot("same", storage: storage, mode: .all)
    } matching: { issue in
      issue.mentions("record mode is .all")
    }

    #expect(storage.writes == 1)
  }

  @Test
  func matchingSnapshotDoesNotRecord() async {
    let storage = InMemoryRecordingStrategy(reference: Data("same".utf8))

    await snapshot("same", storage: storage, mode: .failed)

    #expect(storage.writes == 0)
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
