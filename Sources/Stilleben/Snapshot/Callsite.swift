import Foundation
import Testing

/// Struct used to store the callsite of the snapshot from a test.
public struct Callsite {
  public let fileUrl: URL
  public let functionName: String
  /// Where failures are reported in the test
  public let sourceLocation: SourceLocation

  public init(function: StaticString, sourceLocation: SourceLocation) {
    fileUrl = URL(fileURLWithPath: sourceLocation.filePath)
    functionName = "\(function)"
    self.sourceLocation = sourceLocation
  }
}
