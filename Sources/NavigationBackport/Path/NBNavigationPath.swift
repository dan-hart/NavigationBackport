import Foundation
import SwiftUI
import LoggingKit

@available(iOS, deprecated: 16.0, message: "Use SwiftUI's Navigation API beyond iOS 15")
/// A type-erased wrapper for an Array of any Hashable types, to be displayed in a `NBNavigationStack`.
public struct NBNavigationPath: ExpressibleByArrayLiteral, Equatable {
  public typealias ArrayLiteralElement = NBPathComponent
    
  public var components: [NBPathComponent]

  /// The number of screens in the path.
  public var count: Int { components.count }

  /// WHether the path is empty.
  public var isEmpty: Bool { components.isEmpty }

  public init(arrayLiteral elements: NBPathComponent...) {
    self.components = elements
  }
    
  public init(_ elements: [NBPathComponent] = []) {
    self.components = elements
  }

  public init<S: Sequence>(_ elements: S) where S.Element: NBPathComponentable {
      self.init(elements.map { $0 })
  }

  public mutating func append(_ value: NBPathComponent) {
      components.append(value)
      UALog(.info, eventType: .other("Navigation"), message: "[\(NBNavigationPath.self)] appended \(value.debugDescription) to path.")
  }

  public mutating func removeLast(_ k: Int = 1) {
      components.removeLast(k)
  }
}

public extension NBNavigationPath {
    /// Pushes a new screen via a push navigation.
    /// - Parameter screen: The screen to push.
    mutating func push(_ screen: NBPathComponent) {
        components.push(screen)
    }
    
    /// Pops a given number of screens off the stack.
    /// - Parameter count: The number of screens to go back. Defaults to 1.
    mutating func pop(_ count: Int = 1) {
        components.pop(count)
    }
    
    /// Pops to a given index in the array of screens. The resulting screen count
    /// will be index.
    /// - Parameter index: The index that should become top of the stack.
    mutating func popTo(index: Int) {
        components.popTo(index: index)
    }
    
    /// Pops to the root screen (index 0). The resulting screen count
    /// will be 1.
    mutating func popToRoot() {
        components.popToRoot()
    }
    
    /// Pops to the topmost (most recently pushed) screen in the stack
    /// that satisfies the given condition. If no screens satisfy the condition,
    /// the screens array will be unchanged.
    /// - Parameter condition: The predicate indicating which screen to pop to.
    /// - Returns: A `Bool` indicating whether a screen was found.
    @discardableResult
    mutating func popTo(where condition: (NBPathComponent) -> Bool) -> Bool {
        components.popTo(where: condition)
    }
}

public extension NBNavigationPath {
    /// Pops to the topmost (most recently pushed) screen in the stack
    /// equal to the given screen. If no screens are found,
    /// the screens array will be unchanged.
    /// - Parameter screen: The predicate indicating which screen to go back to.
    /// - Returns: A `Bool` indicating whether a matching screen was found.
    @discardableResult
    mutating func popTo(_ screen: NBPathComponent) -> Bool {
        return components.popTo(screen)
    }
    
    /// Pops to the topmost (most recently pushed) screen in the stack
    /// equal to the given screen. If no screens are found,
    /// the screens array will be unchanged.
    /// - Parameter screen: The predicate indicating which screen to go back to.
    /// - Returns: A `Bool` indicating whether a matching screen was found.
    @discardableResult
    mutating func popTo<T: NBPathComponentable>(_ screenType: T.Type) -> Bool {
        return popTo(where: { $0 is T })
    }
}

