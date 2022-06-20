import Foundation
import UIKit

class TestLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        backgroundColor = .systemBackground
        font = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
