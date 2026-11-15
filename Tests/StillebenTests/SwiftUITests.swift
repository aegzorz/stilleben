import Stilleben
import SwiftUI
import XCTest

@MainActor
final class SwiftUITests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)

  func testSimpleText() async throws {
    await matcher
      .sizing(.intrinsic)
      .locales(.english, .swedish)
      .colorSchemes(.light, .dark)
      .dynamicTypeSizes(.large, .accessibility5)
      .match {
        Text("Hello World!", bundle: .module)
          .padding()
          .background(.background)
      }
  }

  func testNavigation() async throws {
    await matcher
      .sizing(.device)
      .match {
        NavigationView {
          Text("Content View")
            .navigationTitle("Title")
        }
      }
  }

  func testShortScrollview() async throws {
    await matcher
      .ignoresSafeArea()
      .match {
        ItemList(count: 3)
          .background(.background)
      }
  }

  func testLongScrollview() async throws {
    await matcher
      .ignoresSafeArea()
      .match {
        ItemList(count: 12)
          .background(.background)
      }
  }
}
