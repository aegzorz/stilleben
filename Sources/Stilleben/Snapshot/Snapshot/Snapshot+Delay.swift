import Foundation
import Combine

public enum SnapshotDelay {
    case milliseconds(Double)
    case none
}

extension Snapshot {
    /// Delays the snapshotting for a set time.
    /// - Parameter delay: Delay
    public func delay(_ delay: SnapshotDelay) -> Self {
        return map { value in
            switch delay {
            case .milliseconds(let milliseconds):
                if #available(iOS 16.0, *) {
                    try await Task.sleep(for: .milliseconds(milliseconds))
                } else {
                    try await Task.sleep(nanoseconds: UInt64(milliseconds * 1_000_000))
                }
            case .none:
                break
            }
            return value
        }
    }    
}
