import Foundation

public extension SnapshotContext.Key where Value == Device {
  static var device: Self {
    SnapshotContext.Key(name: "device")
  }
}

extension SnapshotContext {
  /// The device the snapshot is rendered for, ``Device/iPhone18Pro`` unless configured
  var device: Device {
    value(for: .device) ?? .iPhone18Pro
  }
}

public extension Snapshot {
  /// Renders the snapshot for a specific ``Device``
  func device(_ device: Device) -> Self {
    context.set(value: device, for: .device)
    return self
  }
}
