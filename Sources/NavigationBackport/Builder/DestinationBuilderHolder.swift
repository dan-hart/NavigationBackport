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

  func build<T>(_ typedData: T, with identifier: String?) -> AnyView {
    let base = (typedData as? AnyHashable)?.base
    if let identifier = identifier {
      if let builder = builders[identifier], let output = builder(typedData) {
        return output
      } else {
          UALog(.error, eventType: .other("Navigation"), message: "DestinationBuilderHolder has no destination for type [\(T.self)] and identifier [\(identifier)]. Call Stack: [\(Thread.callStackSymbols)]")
          assertionFailure("No view builder found for type \(identifier)")
      }
    } else {
      var possibleMirror: Mirror? = Mirror(reflecting: base ?? typedData)
      while let mirror = possibleMirror {
        let key = Self.identifier(for: mirror.subjectType)

        if let builder = builders[key], let output = builder(typedData) {
          return output
        }
        possibleMirror = mirror.superclassMirror
      }
        UALog(.warn, eventType: .other("Navigation"), message: "[\(DestinationBuilderHolder.self)] has no destination for type [\(T.self)] and missing identifier. Call Stack: [\(Thread.callStackSymbols)]")
        assertionFailure("No destination with type \(typedData.self) exists")
    }
    return AnyView(Image(systemName: "exclamationmark.triangle"))
  }
}
