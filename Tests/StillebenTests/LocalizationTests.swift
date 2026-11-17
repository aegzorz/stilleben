import CatalogFixtures
import StringsFixtures
import SwiftUI
import XCTest
@testable import Stilleben

/// Strings looked up in Swift package modules, through every API app code uses, must follow the snapshot's locale
@MainActor
final class LocalizationTests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)
    .locales(.english, .swedish)

  func testStringCatalogInSwiftUI() async {
    await matcher.match {
      LocalizedStringsView(bundle: CatalogFixtures.bundle)
    }
  }

  func testStringsFilesInSwiftUI() async {
    await matcher.match {
      LocalizedStringsView(bundle: StringsFixtures.bundle)
    }
  }

  func testStringCatalogInUIKit() async {
    let swedish = await lookups(in: CatalogFixtures.bundle)

    assertAll(swedish, equal: "Hej från en String Catalog")
  }

  func testStringsFilesInUIKit() async {
    let swedish = await lookups(in: StringsFixtures.bundle)

    assertAll(swedish, equal: "Hej från strings-filer")
  }

  /// Snapshots the UIKit view controller in English and Swedish, returning the strings it resolved in Swedish
  private func lookups(in bundle: Bundle, function: StaticString = #function) async -> [(api: String, text: String)] {
    var produced: [LocalizedStringsViewController] = []
    await matcher.match(function: function) { @MainActor () -> UIViewController in
      let viewController = LocalizedStringsViewController(bundle: bundle)
      produced.append(viewController)
      return viewController
    }
    return produced.last?.lookups ?? []
  }

  private func assertAll(_ lookups: [(api: String, text: String)], equal expected: String, line: UInt = #line) {
    XCTAssertFalse(lookups.isEmpty, line: line)
    for lookup in lookups {
      XCTAssertEqual(lookup.text, expected, "\(lookup.api) didn't follow the snapshot's locale", line: line)
    }
  }
}
