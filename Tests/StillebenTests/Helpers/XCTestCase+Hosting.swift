import UIKit
import XCTest

extension XCTestCase {
  /// Skips tests whose snapshots contain Liquid Glass when they run unhosted, where glass content isn't rendered
  func skipUnlessHosted() throws {
    try XCTSkipIf(
      UIApplication.shared.connectedScenes.isEmpty,
      "Liquid Glass is only rendered in hosted tests; run this test in the TestHost app",
    )
  }
}
