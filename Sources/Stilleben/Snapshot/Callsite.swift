import Foundation

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
