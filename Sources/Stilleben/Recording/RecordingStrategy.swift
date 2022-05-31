import Foundation
import UIKit

public protocol RecordingStrategy {
    func read(context: SnapshotContext) async throws -> Data?
    func write(data: Data, context: SnapshotContext) async throws
}
