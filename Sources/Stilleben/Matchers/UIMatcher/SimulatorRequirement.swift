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

  /// Describes how the running simulator differs from the requirement, or `nil` when it matches
  func mismatch(
    environment: [String: String] = ProcessInfo.processInfo.environment,
    operatingSystemVersion: OperatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion,
  ) -> String? {
    let actualModel = environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "an unknown device"
    let version = operatingSystemVersion
    let actualVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

    let modelMatches = modelIdentifier.map { $0 == actualModel } ?? true
    let versionMatches = osVersion.map { actualVersion == $0 || actualVersion.hasPrefix($0 + ".") } ?? true
    guard !modelMatches || !versionMatches else { return nil }

    let expected = [modelIdentifier, osVersion.map { "iOS \($0)" }].compactMap(\.self).joined(separator: " on ")
    return "Snapshots need \(expected), but the tests run on \(actualModel) on iOS \(actualVersion)"
  }
}
