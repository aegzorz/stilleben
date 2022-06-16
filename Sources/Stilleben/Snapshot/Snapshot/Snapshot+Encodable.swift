import Foundation

extension Snapshot where Value: Encodable {
    func diffJson() -> Snapshot<Diff> {
        encodeJson().record(using: .localFile).diff(using: .text)
    }

    public typealias Configure = (JSONEncoder) -> Void

    public func encodeJson(_ configure: Configure? = nil) -> Snapshot<Data> {
        context.set(value: "json", for: .fileExtension)

        return map { value in
            let encoder = JSONEncoder()
            if let configure = configure {
                configure(encoder)
            } else {
                encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
            }
            return try encoder.encode(value)
        }
    }
}
