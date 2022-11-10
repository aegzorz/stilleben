# Stilleben

Modern snapshot testing written in Swift.

Used to for testing snapshots of mostly UI components but also models and other types.

Example of snapshot testing a SwiftUI view:
```swift
import XCTest
import Stilleben

final class SomeViewTests: XCTestCase {
    private let matcher = UIMatcher()
        .assertSimulator(modelIdentifier: "iPhone14,7")
        .sizing(.dynamicHeight)

    func testSomeView() async throws {
        await matcher
            .colorSchemes(.dark)
            .match {
                NavigationView {
                    SomeView()
                }
            }
    }
}
```

It also supports snapshot testing UIKit view controllers or views:

```swift
import XCTest
import Stilleben

final class SomeViewControllerTests: XCTestCase {
    private let matcher = UIMatcher()
        .assertSimulator(modelIdentifier: "iPhone14,7")
        .sizing(.screen)
    
    func testSomeViewController() async throws {
        await matcher
            .match { @MainActor () -> UIViewController in
                SomeViewController()
            }
    }
    
    func testSimpleLabel() async throws {
        await matcher
            .sizing(.intrinsic)
            .match { @MainActor () -> UIView in
                SomeView()
            }
    }
}
```
