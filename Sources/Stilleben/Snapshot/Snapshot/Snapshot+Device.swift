import Foundation

public extension SnapshotContext.Key where Value == Device {
  static var device: Self {
    SnapshotContext.Key(name: "device")
  }
}

extension SnapshotContext {
  /// The device the snapshot is rendered for
  /// - Throws: ``ConfigurationError/missingDevice`` when no device was set with ``Snapshot/device(_:)``
  var device: Device {
    get throws {
      try value(for: .device).unwrap(error: ConfigurationError.missingDevice)
    }
  }
}

public extension Snapshot {
  /// Renders the snapshot for a specific ``Device``
  func device(_ device: Device) -> Self {
    context.set(value: device, for: .device)
    return self
  }
}
