import Foundation

extension SnapshotContext.Key where Value == Callsite {
    public static var callsite: Self {
        SnapshotContext.Key(name: "callsite")
    }
}
