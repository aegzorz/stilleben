import XCTest
import Stilleben
import SwiftUI

final class AssertTests: XCTestCase {
    func testWrongSimulator() async throws {
        XCTExpectFailure { issue in
            issue.compactDescription.contains("Wrong simulator used")
        }

        await Snapshot {
            Data()
        }
        .assertSimulator(modelIdentifier: "Dummy")
        .record(using: MockRecordingStrategy())
        .diff(using: MockDiffingStrategy())
        .match()
    }

    func testWrongDisplayScale() async throws {
        XCTExpectFailure { issue in
            issue.compactDescription.contains("Wrong display scale detected")
        }

        await Snapshot {
            Data()
        }
        .assertDisplayScale(3)
        .record(using: MockRecordingStrategy())
        .diff(using: MockDiffingStrategy())
        .match()
    }
}

private struct MockRecordingStrategy: RecordingStrategy {
    func read(context: SnapshotContext) async throws -> Data? {
        Data()
    }

    func write(data: Data, context: SnapshotContext) async throws {

    }
}

private struct MockDiffingStrategy: DiffingStrategy {
    func diff(actual: Data, expected: Data) async throws -> Diff {
        .same
    }
}
