import Foundation
import SwiftUI
import LoggingKit

public extension View {
  @available(iOS, deprecated: 16.0, message: "Use SwiftUI's Navigation API beyond iOS 15")
    func nbNavigationDestination<D: Hashable, C: View>(_ identifier: String? = nil, for pathElementType: D.Type, @ViewBuilder destination builder: @escaping (D) -> C) -> some View {
        return modifier(DestinationBuilderModifier(identifier: identifier, typedDestinationBuilder: { AnyView(builder($0)) }))
  }
}
