import Foundation

/// Errors for snapshots or matchers that are set up in a way that can't produce a meaningful snapshot
enum ConfigurationError: LocalizedError, Equatable {
  /// The snapshot has no ``Device`` to be rendered for
  case missingDevice
  /// A ``UIMatcher`` permutation is empty, so no snapshots would be taken
  case emptyPermutation(String)
  /// The tests run on another simulator than the one required with ``UIMatcher/assertSimulator(modelIdentifier:osVersion:)``
  case wrongSimulator(expected: String, actual: String)
  /// The snapshot has no file extension to record it with
  case missingFileExtension
  /// The snapshot has no name components to name its recording
  case missingRecordingName

  var errorDescription: String? {
    switch self {
    case .missingDevice:
      "No device to render the snapshot for: set one with .device(_:)"
    case let .emptyPermutation(name):
      "\(name) is empty, so no snapshots would be taken"
    case let .wrongSimulator(expected, actual):
      "Snapshots need \(expected), but the tests run on \(actual)"
    case .missingFileExtension:
      "Unable to record the snapshot: no file extension was set"
    case .missingRecordingName:
      "Unable to name the recording: no name components were set"
    }
  }
}
