import SwiftUI

/// An object available via the environment that gives access to the current path.
/// Supports push and pop operations when `Screen` conforms to `NBScreen`.
@MainActor
public class NBPathNavigator: ObservableObject {
  private let pathBinding: Binding<NBNavigationPath>

  /// The current navigation path.
  public var path: NBNavigationPath {
    get { pathBinding.wrappedValue }
    set { pathBinding.wrappedValue = newValue }
  }

  init(_ pathBinding: Binding<NBNavigationPath>) {
    self.pathBinding = pathBinding
  }
}
