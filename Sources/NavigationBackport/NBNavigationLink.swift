import Foundation
import SwiftUI
import LoggingKit

@available(iOS, deprecated: 16.0, message: "Use SwiftUI's Navigation API beyond iOS 15")
/// When value is non-nil, shows the destination associated with its type.
public struct NBNavigationLink<P: Hashable, Label: View>: View {
  var identifier: String?
  var value: P?
  var label: Label

  @EnvironmentObject var pathAppender: PathAppender

  public init(_ identifier: String? = nil, value: P?, @ViewBuilder label: () -> Label) {
    self.identifier = identifier
    self.value = value
    self.label = label()
  }

  public var body: some View {
    // TODO: Ensure this button is styled more like a NavigationLink within a List.
    // See: https://gist.github.com/tgrapperon/034069d6116ff69b6240265132fd9ef7
    Button(
      action: {
          guard let value = value else { return }
          if identifier == nil {
              pathAppender.append?(.init(id: "", value))
              UALog(.warn, eventType: .other("Navigation"), message: "Tapped [\(NBNavigationLink.self)] with value [\(value)] of type [\(P.self)] without an identifier.")
          } else {
              pathAppender.append?(.init(id: identifier!, value))
          }
      },
      label: { label }
    )
  }
}

public extension NBNavigationLink where Label == Text {
  init(_ identifier: String, _ titleKey: LocalizedStringKey, value: P?) {
    self.init(identifier, value: value) { Text(titleKey) }
  }

  init<S>(_ identifier: String, _ title: S, value: P?) where S: StringProtocol {
    self.init(identifier, value: value) { Text(title) }
  }
}
