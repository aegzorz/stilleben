import Foundation

public extension Snapshot {
    func addDeviceName(add: Bool = true) -> Self {
        guard add, let deviceName = ProcessInfo().environment["SIMULATOR_DEVICE_NAME"]?.replacingOccurrences(of: " ", with: "_") else {
            return self
        }
        return recordingNameComponent(add: deviceName)
    }
}
