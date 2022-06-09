import Foundation
import XCTest

extension Snapshot where Value == Diff {
    public func match(file: StaticString = #file, line: UInt = #line) async {
        do {
            try await map { diff in
                switch diff {
                case .same:
                    return
                case .different(let description, let attachments):
                    let callsite = try context.value(for: .callsite).unwrap()

                    XCTContext.runActivity(named: callsite.functionName) { activity in
                        attachments.forEach(activity.add)
                    }

                    return XCTFail(description, file: file, line: line)
                }
            }
            .produce()
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
}
