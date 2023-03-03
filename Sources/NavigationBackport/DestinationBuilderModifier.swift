import Foundation
import SwiftUI
import LoggingKit
import SwiftPrettyPrint

/// Modifier for appending a new destination builder.
struct DestinationBuilderModifier<TypedData>: ViewModifier {
  let typedDestinationBuilder: DestinationBuilder<TypedData>

  @EnvironmentObject var destinationBuilder: DestinationBuilderHolder

  func body(content: Content) -> some View {
    destinationBuilder.appendBuilder(typedDestinationBuilder)

    return content
      .environmentObject(destinationBuilder)
      .onAppear {
          Pretty.print(label: "destination builder", destinationBuilder)
          Pretty.print(label: "typed destination builder", typedDestinationBuilder)
          UALog(.info, eventType: .other("Navigation"), message: "[\(DestinationBuilderModifier.self)] did appear with type [\(TypedData.self)] for view [\(content.prettyPrint(label: "content"))].")
      }
  }
}
