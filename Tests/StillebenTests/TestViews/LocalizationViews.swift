import SwiftUI
import UIKit

/// Looks up the key "greeting" in a bundle the ways app code does, without knowing about snapshots
struct LocalizedLookups {
  let bundle: Bundle

  /// Every non-SwiftUI way of looking up the key, labelled by the API used
  func strings() -> [(api: String, text: String)] {
    [
      ("NSLocalizedString", NSLocalizedString("greeting", bundle: bundle, comment: "")),
      ("String(localized:bundle:)", String(localized: "greeting", bundle: bundle)),
      ("LocalizedStringResource", String(localized: resource)),
      ("Bundle.localizedString", bundle.localizedString(forKey: "greeting", value: nil, table: nil)),
    ]
  }

  var resource: LocalizedStringResource {
    LocalizedStringResource("greeting", bundle: .atURL(bundle.bundleURL))
  }
}

/// SwiftUI view showing the key looked up every way, one row per API
struct LocalizedStringsView: View {
  let bundle: Bundle

  var body: some View {
    let lookups = LocalizedLookups(bundle: bundle)
    VStack(alignment: .leading, spacing: 8) {
      row("Text(_:bundle:)", Text(LocalizedStringKey("greeting"), bundle: bundle))
      row("Text(LocalizedStringResource)", Text(lookups.resource))
      ForEach(lookups.strings(), id: \.api) { lookup in
        row(lookup.api, Text(verbatim: lookup.text))
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.background)
  }

  private func row(_ api: String, _ text: Text) -> some View {
    VStack(alignment: .leading) {
      Text(verbatim: api).font(.caption).foregroundStyle(.secondary)
      text
    }
  }
}

/// UIKit view controller showing the key looked up every way, keeping the strings it resolved
final class LocalizedStringsViewController: UIViewController {
  let bundle: Bundle
  private(set) var lookups: [(api: String, text: String)] = []

  init(bundle: Bundle) {
    self.bundle = bundle
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    lookups = LocalizedLookups(bundle: bundle).strings()

    let stack = UIStackView(arrangedSubviews: lookups.map { lookup in
      let label = UILabel()
      label.numberOfLines = 0
      label.font = .preferredFont(forTextStyle: .body)
      label.text = "\(lookup.api)\n\(lookup.text)"
      return label
    })
    stack.axis = .vertical
    stack.spacing = 8
    stack.isLayoutMarginsRelativeArrangement = true
    stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
