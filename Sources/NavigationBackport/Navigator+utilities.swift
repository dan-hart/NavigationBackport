import Foundation

public extension NBPathNavigator {
  /// Pushes a new screen via a push navigation.
  /// - Parameter screen: The screen to push.
  func push(_ screen: NBPathComponent) {
    path.push(screen)
  }

  /// Pops a given number of screens off the stack.
  /// - Parameter count: The number of screens to go back. Defaults to 1.
  func pop(_ count: Int = 1) {
    path.pop(count)
  }

  /// Pops to a given index in the array of screens. The resulting screen count
  /// will be index.
  /// - Parameter index: The index that should become top of the stack.
  func popTo(index: Int) {
    path.popTo(index: index)
  }

  /// Pops to the root screen (index 0). The resulting screen count
  /// will be 1.
  func popToRoot() {
    path.popToRoot()
  }

  /// Pops to the topmost (most recently pushed) screen in the stack
  /// that satisfies the given condition. If no screens satisfy the condition,
  /// the screens array will be unchanged.
  /// - Parameter condition: The predicate indicating which screen to pop to.
  /// - Returns: A `Bool` indicating whether a screen was found.
  @discardableResult
  func popTo(where condition: (NBPathComponent) -> Bool) -> Bool {
    path.popTo(where: condition)
  }
}
