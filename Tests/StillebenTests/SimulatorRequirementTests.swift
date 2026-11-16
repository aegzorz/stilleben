import SwiftUI
import XCTest
@testable import Stilleben

@MainActor
final class SimulatorRequirementTests: XCTestCase {
  private let iPhone18Pro = ["SIMULATOR_MODEL_IDENTIFIER": "iPhone19,2"]
  private let iOS27_2 = OperatingSystemVersion(majorVersion: 27, minorVersion: 2, patchVersion: 0)

  func testMatchingSimulator() {
    let requirement = SimulatorRequirement(modelIdentifier: "iPhone19,2", osVersion: "27.2")

    XCTAssertNil(requirement.mismatch(environment: iPhone18Pro, operatingSystemVersion: iOS27_2))
  }

  func testVersionIsMatchedAsPrefix() {
    let patched = OperatingSystemVersion(majorVersion: 27, minorVersion: 2, patchVersion: 1)
    let later = OperatingSystemVersion(majorVersion: 27, minorVersion: 20, patchVersion: 0)

    XCTAssertNil(SimulatorRequirement(osVersion: "27.2").mismatch(environment: iPhone18Pro, operatingSystemVersion: patched))
    XCTAssertNotNil(SimulatorRequirement(osVersion: "27.2").mismatch(environment: iPhone18Pro, operatingSystemVersion: later))
  }

  func testWrongModel() {
    let mismatch = SimulatorRequirement(modelIdentifier: "iPhone19,4").mismatch(environment: iPhone18Pro, operatingSystemVersion: iOS27_2)

    XCTAssertEqual(mismatch, "Snapshots need iPhone19,4, but the tests run on iPhone19,2 on iOS 27.2.0")
  }

  func testWrongSimulatorDoesNotRecord() async {
    let recording = CountingRecordingStrategy()
    XCTExpectFailure { $0.compactDescription.contains("Nothing was compared or recorded") }

    await UIMatcher()
      .assertSimulator(osVersion: "1.0")
      .recording(recording)
      .match {
        Text("Never rendered")
      }

    XCTAssertEqual(recording.reads + recording.writes, 0)
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
