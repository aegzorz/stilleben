import Stilleben
import SwiftUI
import XCTest

@MainActor
final class SwiftUITests: XCTestCase {
  private let matcher = UIMatcher()
    .sizing(.dynamicHeight)

  func testSimpleText() async throws {
    await matcher
      .sizing(.intrinsic)
      .locales(.english, .swedish)
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
        ItemList(count: 25)
          .background(.background)
      }
  }

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

  func testLongScrollviewInTabView() async {
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
