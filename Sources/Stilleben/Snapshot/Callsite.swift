import Foundation

/// Struct used to store the callsite of the snapshot from a test.
public struct Callsite {
    public let fileUrl: URL
    public let functionName: String
    public let line: UInt

    public init(file: StaticString, function: StaticString, line: UInt) {
        fileUrl = URL(fileURLWithPath: "\(file)")
        functionName = "\(function)"
        self.line = line
    }
}
