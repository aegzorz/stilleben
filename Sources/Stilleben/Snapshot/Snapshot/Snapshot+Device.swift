import Foundation

public extension Snapshot {
    /// Adds the current device name to the recording name components
    /// - Parameter add: Boolean value indicating whether to add or not, default is `true`.
    func addDeviceName(add: Bool = true) -> Self {
        guard add, let deviceName = ProcessInfo().environment["SIMULATOR_DEVICE_NAME"]?.replacingOccurrences(of: " ", with: "_") else {
            return self
        }
        return recordingNameComponent(add: deviceName)
    }
}
