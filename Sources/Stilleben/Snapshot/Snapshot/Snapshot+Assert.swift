import Foundation
import XCTest

public extension Snapshot {
    func assertSimulator(modelIdentifier expected: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let actual = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"
        XCTAssertEqual(actual, expected, "Wrong simulator used", file: file, line: line)
        return self
    }

    func assertDisplayScale(_ expected: CGFloat, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let actual = UIScreen.main.scale
        XCTAssertEqual(actual, expected, "Wrong display scale detected", file: file, line: line)
        return self
    }
}
