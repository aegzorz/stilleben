import Foundation
import XCTest

public extension Snapshot {
    func assertSimulator(modelIdentifier expected: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let actual = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"
        XCTAssert(actual == expected, "Wrong simulator used, expected: \(expected) actual: \(actual)", file: file, line: line)
        return self
    }

    func assertDisplayScale(_ expected: CGFloat, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let actual = UIScreen.main.scale
        XCTAssert(actual == expected, "Wrong display scale detected, expected: \(expected) actual: \(actual)", file: file, line: line)
        return self
    }
}
