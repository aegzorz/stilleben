import Foundation
import Combine

extension Snapshot where Value: Encodable {
    /// Allows diffing any `Encodable` as JSON, recording using `localFile` recording strategy
    public func diffJson() -> Snapshot<Diff> {
        encodeJson().record(using: .localFile).diff(using: .text)
    }

    public func encodeJson(encoder: JSONEncoder = JSONEncoder()) -> Snapshot<Data> {
        context.set(value: "json", for: .fileExtension)

        return map { value in
            return try encoder.encode(value)
        }
    }
}
