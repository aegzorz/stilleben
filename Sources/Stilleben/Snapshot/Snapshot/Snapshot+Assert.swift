import Foundation
import XCTest

public extension Snapshot {
    /// Assert that a specific iOS simulator is being used
    /// - Parameter modelIdentifier: The expected model used to take snapshots, i.e. "iPhone10,1" for iPhone 8
    func assertSimulator(modelIdentifier expected: String?, file: StaticString = #filePath, line: UInt = #line) -> Self {
        guard let expected else { return self }

        let actual = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"
        XCTAssertEqual(actual, expected, "Wrong simulator used", file: file, line: line)
        return self
    }

    /// Assert that a specific display scale is being used.
    /// - Parameter expected: The expected display scale (1.0, 2.0 or 3.0 for example)
    func assertDisplayScale(_ expected: CGFloat?, file: StaticString = #filePath, line: UInt = #line) -> Self {
        guard let expected else { return self }

        let actual = UIScreen.main.scale
        XCTAssertEqual(actual, expected, "Wrong display scale detected", file: file, line: line)
        return self
    }
}
