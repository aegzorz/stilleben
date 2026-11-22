import Stilleben
import SwiftUI
import Testing

/// Strings looked up in the app's own String Catalog (`Bundle.main`), through every API app code uses, must follow
/// the snapshot's locale. Only hosted tests have the app as `Bundle.main`.
@MainActor
@Suite
struct HostedLocalizationTests {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)
    .locales(Locale(identifier: "en-US"), Locale(identifier: "sv-SE"))

  @Test
  func appStringCatalogInSwiftUI() async {
    await matcher.match {
      LocalizedStringsView(bundle: .main)
    }
  }

  @Test
  func appStringCatalogInUIKit() async {
    var produced: [LocalizedStringsViewController] = []
    await matcher.match { @MainActor () -> UIViewController in
      let viewController = LocalizedStringsViewController(bundle: .main)
      produced.append(viewController)
      return viewController
    }

    let swedish = produced.last?.lookups ?? []
    #expect(!swedish.isEmpty)
    for lookup in swedish {
      #expect(lookup.text == "Hej från appen", "\(lookup.api) didn't follow the snapshot's locale")
    }
  }
}
