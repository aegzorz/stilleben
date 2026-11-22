import SwiftUI
import Testing
@testable import Stilleben

/// Misconfigured snapshots fail with a clear error instead of silently falling back or taking no snapshots
@MainActor
@Suite
struct ConfigurationErrorTests {
  @Test
  func emptyPermutationFailsWithoutSnapshots() async {
    await withKnownIssue {
      await UIMatcher()
        .devices()
        .match {
          Text("Never rendered")
        }
    } matching: { issue in
      issue.mentions("devices is empty, so no snapshots would be taken")
    }
  }

  @Test
  func emptyPermutationFailsWithoutSnapshotsInUIKit() async {
    await withKnownIssue {
      await UIMatcher()
        .devices()
        .match { @MainActor () -> UIView in
          UIView()
        }
    } matching: { issue in
      issue.mentions("devices is empty, so no snapshots would be taken")
    }
  }

  @Test
  func matcherValidatesEveryPermutation() throws {
    #expect(throws: ConfigurationError.emptyPermutation("colorSchemes")) {
      try UIMatcher().colorSchemes().validate()
    }
    #expect(throws: ConfigurationError.emptyPermutation("dynamicTypeSizes")) {
      try UIMatcher().dynamicTypeSizes().validate()
    }
    #expect(throws: ConfigurationError.emptyPermutation("locales")) {
      try UIMatcher().locales().validate()
    }
    try UIMatcher().validate()
  }

  @Test
  func snapshotWithoutDeviceThrows() async {
    await #expect(throws: ConfigurationError.missingDevice) {
      try await Snapshot {
        Text("Never rendered")
      }
      .inHostingController()
      .inWindow()
      .produce()
    }
  }
}
