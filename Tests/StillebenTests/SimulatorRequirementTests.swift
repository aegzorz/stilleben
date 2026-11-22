import SwiftUI
import Testing
@testable import Stilleben

@MainActor
@Suite
struct SimulatorRequirementTests {
  private let iPhone18Pro = ["SIMULATOR_MODEL_IDENTIFIER": "iPhone19,2"]
  private let iOS27_2 = OperatingSystemVersion(majorVersion: 27, minorVersion: 2, patchVersion: 0)

  @Test
  func matchingSimulator() throws {
    let requirement = SimulatorRequirement(modelIdentifier: "iPhone19,2", osVersion: "27.2")

    try requirement.validate(environment: iPhone18Pro, operatingSystemVersion: iOS27_2)
  }

  @Test
  func versionIsMatchedAsPrefix() throws {
    let patched = OperatingSystemVersion(majorVersion: 27, minorVersion: 2, patchVersion: 1)
    let later = OperatingSystemVersion(majorVersion: 27, minorVersion: 20, patchVersion: 0)

    try SimulatorRequirement(osVersion: "27.2").validate(environment: iPhone18Pro, operatingSystemVersion: patched)
    #expect(throws: ConfigurationError.self) {
      try SimulatorRequirement(osVersion: "27.2").validate(environment: iPhone18Pro, operatingSystemVersion: later)
    }
  }

  @Test
  func wrongModel() {
    let requirement = SimulatorRequirement(modelIdentifier: "iPhone19,4")

    #expect(throws: ConfigurationError.wrongSimulator(expected: "iPhone19,4", actual: "iPhone19,2 on iOS 27.2.0")) {
      try requirement.validate(environment: iPhone18Pro, operatingSystemVersion: iOS27_2)
    }
  }

  @Test
  func wrongSimulatorDoesNotRecord() async {
    let recording = CountingRecordingStrategy()
    await withKnownIssue {
      await UIMatcher()
        .assertSimulator(osVersion: "1.0")
        .recording(recording)
        .match {
          Text("Never rendered")
        }
    } matching: { issue in
      issue.mentions("Nothing was compared or recorded")
    }

    #expect(recording.reads + recording.writes == 0)
  }
}

private final class CountingRecordingStrategy: RecordingStrategy {
  var reads = 0
  var writes = 0

  func read(context: SnapshotContext) async throws -> Data? {
    reads += 1
    return nil
  }

  func write(data: Data, context: SnapshotContext) async throws {
    writes += 1
  }
}
