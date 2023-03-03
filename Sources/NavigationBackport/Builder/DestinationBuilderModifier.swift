import Foundation
import SwiftUI
import LoggingKit

/// Modifier for appending a new destination builder.
struct DestinationBuilderModifier<TypedData>: ViewModifier {
  let identifier: String?
  let typedDestinationBuilder: DestinationBuilder<TypedData>

  @EnvironmentObject var destinationBuilder: DestinationBuilderHolder

  func body(content: Content) -> some View {
    destinationBuilder.appendBuilder(identifier, typedDestinationBuilder)

    return content
      .environmentObject(destinationBuilder)
      .onAppear {
          if identifier == nil {
              UALog(.warn, eventType: .other("Navigation"), message: "View with type [\(TypedData.self)] did appear with missing identifier.")
          }
      }
  }
}
