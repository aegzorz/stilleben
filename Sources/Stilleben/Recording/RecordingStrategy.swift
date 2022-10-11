import Foundation
import UIKit

/// Protocol describing how recorded snapshots are read and written
public protocol RecordingStrategy {
    /// Reads a previously recorded snapshot
    /// - Parameter context: The context of the current snapshot
    /// - Returns: The recorded `Data` or `nil` if no recording was found
    func read(context: SnapshotContext) async throws -> Data?
    /// Writes the current snapshot to persistent storage
    /// - Parameter data: Snapshot data to persist for subsequent runs
    /// - Parameter context: The context of the current snapshot
    func write(data: Data, context: SnapshotContext) async throws
}
