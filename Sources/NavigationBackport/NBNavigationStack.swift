import Foundation
import SwiftUI

@available(iOS, deprecated: 16.0, message: "Use SwiftUI's Navigation API beyond iOS 15")
/// A replacement for SwiftUI's `NavigationStack` that's available on older OS versions.
public struct NBNavigationStack<Root: View>: View {
  var unownedPath: Binding<NBNavigationPath>?
  @StateObject var ownedPath = NavigationPathHolder()
  @StateObject var pathAppender = PathAppender()
  @StateObject var destinationBuilder = DestinationBuilderHolder()
  var root: Root

  var typedPath: Binding<NBNavigationPath> {
    if let unownedPath {
      return unownedPath
    } else {
      return Binding {
          ownedPath.path
      } set: { newValue in
          ownedPath.path = newValue
      }
    }
  }

  var content: some View {
    pathAppender.append = { [weak ownedPath] newElement in
      ownedPath?.path.append(newElement)
    }

    return NavigationView {
        Router(rootView: root, screens: $ownedPath.path.components)
    }
    .navigationViewStyle(supportedNavigationViewStyle)
    .environmentObject(ownedPath)
    .environmentObject(pathAppender)
    .environmentObject(destinationBuilder)
    .environmentObject(NBPathNavigator(typedPath))
  }

  public var body: some View {
    if let unownedPath {
      content
        .onChange(of: unownedPath.wrappedValue) {
          ownedPath.path = $0
        }
        .onChange(of: ownedPath.path) { path in
          unownedPath.wrappedValue = path
//          unownedPath.wrappedValue = path.compactMap { component in
//            if let data = component.data.base as? Data {
//              return data
//            }
//              fatalError("Cannot add \(type(of: component.data.base)) to stack of \(Data.self)")
//          }
        }
    } else {
      content
    }
  }

  public init(path: Binding<NBNavigationPath>?, @ViewBuilder root: () -> Root) {
    unownedPath = path
    self.root = root()
  }
    
  public init(@ViewBuilder root: () -> Root) {
    self.init(path: nil, root: root)
  }
}

private var supportedNavigationViewStyle: some NavigationViewStyle {
  #if os(macOS)
    .automatic
  #else
    .stack
  #endif
}
