import Foundation
import SwiftUI

struct ItemList: View {
    let count: Int

    var body: some View {
        ScrollView {
            ForEach(0..<count, id: \.self) { index in
                Item(index: index)
            }
        }
    }

}

struct Item: View {
    let index: Int

    var body: some View {
        Text("Item #\(index + 1)")
            .frame(maxWidth: .infinity)
            .padding()
            .background(colors[index % colors.count].opacity(0.6))
    }

    private let colors: [Color] = [.red, .blue, .green, .yellow, .purple]
}
