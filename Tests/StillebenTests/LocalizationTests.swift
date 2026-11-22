import CatalogFixtures
import StringsFixtures
import SwiftUI
import Testing
@testable import Stilleben

/// Strings looked up in Swift package modules, through every API app code uses, must follow the snapshot's locale
@MainActor
@Suite
struct LocalizationTests {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)
    .locales(.english, .swedish)

  @Test
  func stringCatalogInSwiftUI() async {
    await matcher.match {
      LocalizedStringsView(bundle: CatalogFixtures.bundle)
    }
  }

  @Test
  func stringsFilesInSwiftUI() async {
    await matcher.match {
      LocalizedStringsView(bundle: StringsFixtures.bundle)
    }
  }

  @Test
  func stringCatalogInUIKit() async {
    let swedish = await lookups(in: CatalogFixtures.bundle)

    expectAll(swedish, equal: "Hej från en String Catalog")
  }

  @Test
  func stringsFilesInUIKit() async {
    let swedish = await lookups(in: StringsFixtures.bundle)

    expectAll(swedish, equal: "Hej från strings-filer")
  }

  @Test
  func concurrentSnapshotsKeepTheirOwnLocale() async {
    async let english = lookups(in: CatalogFixtures.bundle, locale: .english)
    async let swedish = lookups(in: CatalogFixtures.bundle, locale: .swedish)

    let (englishLookups, swedishLookups) = await (english, swedish)
    expectAll(englishLookups, equal: "Hello from a String Catalog")
    expectAll(swedishLookups, equal: "Hej från en String Catalog")
  }

  /// Snapshots the UIKit view controller in English and Swedish, or only in `locale`, returning the strings it
  /// resolved in the last locale
  private func lookups(
    in bundle: Bundle,
    locale: Locale? = nil,
    function: StaticString = #function,
    sourceLocation: SourceLocation = #_sourceLocation,
  ) async -> [(api: String, text: String)] {
    var produced: [LocalizedStringsViewController] = []
    let matcher = locale.map { matcher.locales($0) } ?? matcher
    await matcher.match(function: function, sourceLocation: sourceLocation) { @MainActor () -> UIViewController in
      // Suspends before the strings are looked up, like views that load their content first, so concurrent
      // snapshots interleave
      await Task.yield()
      let viewController = LocalizedStringsViewController(bundle: bundle)
      produced.append(viewController)
      return viewController
    }
    return produced.last?.lookups ?? []
  }

  private func expectAll(_ lookups: [(api: String, text: String)], equal expected: String, sourceLocation: SourceLocation = #_sourceLocation) {
    #expect(!lookups.isEmpty, sourceLocation: sourceLocation)
    for lookup in lookups {
      #expect(lookup.text == expected, "\(lookup.api) didn't follow the snapshot's locale", sourceLocation: sourceLocation)
    }
  }
}
