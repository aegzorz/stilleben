import Stilleben
import SwiftUI
import XCTest

/// Snapshots that need a window scene, like Liquid Glass bars, so they run hosted in the TestHost app
@MainActor
final class HostedSwiftUITests: XCTestCase {
  private let matcher = UIMatcher()
    .assertSimulator(modelIdentifier: "iPhone19,2", osVersion: "27.2")
    .sizing(.dynamicHeight)

  // Disabled: applying the device safe area to dynamic height sizing renders accessibility sizes blank
  func disabled_testLongScrollviewInNavigationView() async throws {
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
