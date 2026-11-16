import Foundation

/// The simulator that UI snapshots have to be taken on. Rendering differs between iOS versions and devices
/// (for example fonts, anti-aliasing and system components), so references only match on the simulator
/// they were recorded on.
public struct SimulatorRequirement: Sendable, Equatable {
  /// Model identifier of the simulated device, like `iPhone19,2`
  public var modelIdentifier: String?
  /// iOS version, matched as a prefix: `27.2` matches 27.2 and 27.2.1
  public var osVersion: String?

  public init(modelIdentifier: String? = nil, osVersion: String? = nil) {
    self.modelIdentifier = modelIdentifier
    self.osVersion = osVersion
  }

  /// Throws ``ConfigurationError/wrongSimulator(expected:actual:)`` when the running simulator doesn't meet the requirement
  func validate(
    environment: [String: String] = ProcessInfo.processInfo.environment,
    operatingSystemVersion: OperatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion,
  ) throws {
    let actualModel = environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "an unknown device"
    let version = operatingSystemVersion
    let actualVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

    let modelMatches = modelIdentifier.map { $0 == actualModel } ?? true
    let versionMatches = osVersion.map { actualVersion == $0 || actualVersion.hasPrefix($0 + ".") } ?? true
    guard !modelMatches || !versionMatches else { return }

    let expected = [modelIdentifier, osVersion.map { "iOS \($0)" }].compactMap(\.self).joined(separator: " on ")
    throw ConfigurationError.wrongSimulator(expected: expected, actual: "\(actualModel) on iOS \(actualVersion)")
  }
}
