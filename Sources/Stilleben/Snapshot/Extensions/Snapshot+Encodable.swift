import Foundation

extension Snapshot where Value: Encodable {
    func diffJson() -> Snapshot<Diff> {
        encodeJson().record(using: .localFile).diff(using: .text)
    }

    public func encodeJson() -> Snapshot<Data> {
        context.set(value: "json", for: .fileExtension)

        return map { value in
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            return try encoder.encode(value)
        }
    }
}
