import Stilleben
import SwiftUI
import Testing

/// Snapshots that render differently without a window scene (Liquid Glass bars, rounded corners of grouped lists),
/// so they run hosted in the TestHost app
@MainActor
@Suite
struct HostedSwiftUITests {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)
    .colorSchemes(.light)
    .dynamicTypeSizes(.large)

  @Test
  func listOnFoldable() async throws {
    await matcher
      .devices(.iPhoneDuo, .iPhoneDuoFolded)
      .sizing(.device)
      .colorSchemes(.light)
      .dynamicTypeSizes(.large)
      .match {
        NavigationStack {
          List(1...20, id: \.self) { index in
            Text("Row \(index)")
          }
          .navigationTitle("Foldable")
        }
      }
  }

  @Test
  func longScrollviewInNavigationView() async throws {
    await matcher.match {
      NavigationView {
        ScrollView {
          ItemList(count: 12)
        }
        .navigationTitle("List of items")
      }
    }
  }

  @Test
  func longScrollviewInTabView() async throws {
    await matcher.match {
      TabView {
        NavigationView {
          ScrollView {
            // Leaves an item's height of empty space at the end, so the tab bar's glass doesn't render on top of the last item
            ItemList(count: 12, bottomSpacing: true)
          }
          .navigationTitle("List of items")
        }
        .tabItem {
          Label("List", systemImage: "list.number")
        }
      }
    }
  }
}
