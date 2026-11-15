import Foundation

public extension SnapshotContext.Key where Value == Device {
  static var device: Self {
    SnapshotContext.Key(name: "device")
  }
}

extension SnapshotContext {
  /// The device the snapshot is rendered for, ``Device/iPhone17`` unless configured
  var device: Device {
    value(for: .device) ?? .iPhone17
  }
}

public extension Snapshot {
  /// Renders the snapshot for a specific ``Device``
  func device(_ device: Device) -> Self {
    context.set(value: device, for: .device)
    return self
  }

  /// Adds the name of the snapshot's ``Device`` to the recording name components
  /// - Parameter add: Boolean value indicating whether to add or not, default is `true`.
  func addDeviceName(add: Bool = true) -> Self {
    add ? recordingNameComponent(add: context.device.fileName) : self
  }
}
