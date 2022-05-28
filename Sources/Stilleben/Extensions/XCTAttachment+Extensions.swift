import XCTest

extension XCTAttachment {
    func named(_ name: String) -> Self {
        self.name = name
        return self
    }
}
