import Foundation
import UIKit

public var isRecordingSnapshots = false

public protocol RecordingStrategy {
    func read(context: SnapshotContext) async throws -> Data?
    func write(data: Data, context: SnapshotContext) async throws
}
