import Foundation
import SwiftUI
import LoggingKit

/// Keeps hold of the destination builder closures for a given type or local destination ID.
class DestinationBuilderHolder: ObservableObject {
  static func identifier(for type: Any.Type) -> String {
    String(reflecting: type)
  }

  var builders: [String: (Any) -> AnyView?] = [:]

  init() {
    builders = [:]
  }

  func appendBuilder<T>(_ identifier: String? = nil, _ builder: @escaping (T) -> AnyView) {
    let identifierOrType = identifier ?? Self.identifier(for: T.self)
    builders[identifierOrType] = { data in
      if let typedData = data as? T {
        return builder(typedData)
      } else {
        return nil
      }
    }
  }

  func build<T>(_ incomingDataOrComponent: T, with optionalIdentifier: String?) -> AnyView {
    let errorView = AnyView(Image(systemName: "exclamationmark.triangle"))
      
      var identifier = ""
      if incomingDataOrComponent is NBPathComponent {
          identifier = (incomingDataOrComponent as! NBPathComponent).id
      } else {
          identifier = optionalIdentifier ?? ""
      }
    
    if identifier.isEmpty == false {
        if let builder = builders[identifier], let output = builder(incomingDataOrComponent) ??
            (incomingDataOrComponent is NBPathComponent ? builder((incomingDataOrComponent as! NBPathComponent).data) : nil) {
        return output
      } else {
          UALog(.error, eventType: .other("Navigation"), message: "DestinationBuilderHolder has no destination for type [\(T.self)] and identifier [\(identifier)]. Call Stack: [\(Thread.callStackSymbols)]")
          assertionFailure("No view builder found for type \(identifier)")
      }
    } else {
        var typeString = Self.identifier(for: T.self)
        
        if incomingDataOrComponent is NBPathComponent {
            let component = (incomingDataOrComponent as! NBPathComponent)
            let base = component.data.base
            let typeMirror = Mirror(reflecting: base)
            typeString = Self.identifier(for: typeMirror.subjectType)
        }

        if let builder = builders[typeString],
            let output = builder(incomingDataOrComponent) ??
              (incomingDataOrComponent is NBPathComponent ? builder((incomingDataOrComponent as! NBPathComponent).data) : nil) {
            return output
        } else {
            UALog(.warn, eventType: .other("Navigation"), message: "[\(DestinationBuilderHolder.self)] has no destination for type [\(typeString)] and missing identifier. Call Stack: [\(Thread.callStackSymbols)]")
            assertionFailure("No destination with type \(typeString) exists.")
        }
    }
    return errorView
  }
}
