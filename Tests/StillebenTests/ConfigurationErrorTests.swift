import SwiftUI
import XCTest
@testable import Stilleben

/// Misconfigured snapshots fail with a clear error instead of silently falling back or taking no snapshots
@MainActor
final class ConfigurationErrorTests: XCTestCase {
  func testEmptyPermutationFailsWithoutSnapshots() async {
    XCTExpectFailure { $0.compactDescription.contains("devices is empty, so no snapshots would be taken") }

    await UIMatcher()
      .devices()
      .match {
        Text("Never rendered")
      }
  }

  func testMatcherValidatesEveryPermutation() {
    XCTAssertThrowsError(try UIMatcher().colorSchemes().validate()) { error in
      XCTAssertEqual(error as? ConfigurationError, .emptyPermutation("colorSchemes"))
    }
    XCTAssertThrowsError(try UIMatcher().dynamicTypeSizes().validate()) { error in
      XCTAssertEqual(error as? ConfigurationError, .emptyPermutation("dynamicTypeSizes"))
    }
    XCTAssertThrowsError(try UIMatcher().locales().validate()) { error in
      XCTAssertEqual(error as? ConfigurationError, .emptyPermutation("locales"))
    }
    XCTAssertNoThrow(try UIMatcher().validate())
  }

  func testSnapshotWithoutDeviceThrows() async {
    do {
      _ = try await Snapshot {
        Text("Never rendered")
      }
      .inHostingController()
      .inWindow()
      .produce()
      XCTFail("Expected a missing device error")
    } catch {
      XCTAssertEqual(error as? ConfigurationError, .missingDevice)
    }
  }
}
