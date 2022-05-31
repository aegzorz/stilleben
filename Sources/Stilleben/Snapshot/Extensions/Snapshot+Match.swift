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
                    XCTContext.runActivity(named: context.callsite.functionName) { activity in
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
