import Stilleben
import SwiftUI
import XCTest

/// Strings looked up in the app's own String Catalog (`Bundle.main`), through every API app code uses, must follow
/// the snapshot's locale. Only hosted tests have the app as `Bundle.main`.
@MainActor
final class HostedLocalizationTests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)
    .locales(Locale(identifier: "en-US"), Locale(identifier: "sv-SE"))

  func testAppStringCatalogInSwiftUI() async {
    await matcher.match {
      LocalizedStringsView(bundle: .main)
    }
  }

  func testAppStringCatalogInUIKit() async {
    var produced: [LocalizedStringsViewController] = []
    await matcher.match { @MainActor () -> UIViewController in
      let viewController = LocalizedStringsViewController(bundle: .main)
      produced.append(viewController)
      return viewController
    }

    let swedish = produced.last?.lookups ?? []
    XCTAssertFalse(swedish.isEmpty)
    for lookup in swedish {
      XCTAssertEqual(lookup.text, "Hej från appen", "\(lookup.api) didn't follow the snapshot's locale")
    }
  }
}
