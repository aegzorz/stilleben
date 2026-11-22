import Stilleben
import SwiftUI
import Testing

@MainActor
@Suite
struct SwiftUITests {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)

  @Test
  func simpleText() async throws {
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

  @Test
  func navigation() async throws {
    await matcher
      .sizing(.device)
      .match {
        NavigationView {
          Text("Content View")
            .navigationTitle("Title")
        }
      }
  }

  @Test
  func shortScrollview() async throws {
    await matcher
      .match {
        ItemList(count: 3)
          .background(.background)
      }
  }

  @Test
  func longScrollview() async throws {
    await matcher
      .match {
        ItemList(count: 12)
          .background(.background)
      }
  }
}
