import Foundation
import SwiftUI

struct Router<RootView: View>: View {
  let rootView: RootView

  @Binding var screens: [NBPathComponent]

  init(rootView: RootView, screens: Binding<[NBPathComponent]>) {
    self.rootView = rootView
    _screens = screens
  }

  var pushedScreens: some View {
      Node(allScreens: screens, truncateToIndex: { screens = Array(screens.prefix($0)) }, index: 0, identifier: screens.first?.id)
  }

  private var isActiveBinding: Binding<Bool> {
    screens.isEmpty ? .constant(false) : Binding(
      get: { !screens.isEmpty },
      set: { isShowing in
        guard !isShowing else { return }
        guard !screens.isEmpty else { return }
        screens = []
      }
    )
  }

  var body: some View {
    rootView
      .background(
        NavigationLink(destination: pushedScreens, isActive: isActiveBinding, label: EmptyView.init)
          .hidden()
      )
  }
}
