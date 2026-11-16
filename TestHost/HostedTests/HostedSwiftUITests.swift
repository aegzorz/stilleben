import Stilleben
import SwiftUI
import XCTest

/// Snapshots that need a window scene, like Liquid Glass bars, so they run hosted in the TestHost app
@MainActor
final class HostedSwiftUITests: XCTestCase {
  private let matcher = UIMatcher()
    .sizing(.dynamicHeight)

  func testLongScrollviewInNavigationView() async throws {
    await matcher.match {
      NavigationView {
        ScrollView {
          ItemList(count: 25)
        }
        .navigationTitle("List of items")
      }
    }
  }

  func testLongScrollviewInTabView() async throws {
    await matcher.match {
      TabView {
        NavigationView {
          ScrollView {
            ItemList(count: 25)
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
