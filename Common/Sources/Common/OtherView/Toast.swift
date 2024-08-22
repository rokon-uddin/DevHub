//
//  Toast.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/20/24.
//

import SwiftUI

public struct Toast: View {
  public struct Model {
    var title: String
    var image: String
  }

  let model: Model
  @Binding var show: Bool

  public init(_ model: Model, show: Binding<Bool>) {
    self.model = model
    self._show = show
  }

  public var body: some View {
    VStack {
      Spacer()
      HStack {
        Image(systemName: model.image)
        Text(model.title)
          .accessibilityLabel("Toast message")
          .accessibilityValue(model.title)
      }.font(.headline)
        .foregroundColor(Color.accent)
        .padding([.top, .bottom], 20)
        .padding([.leading, .trailing], 40)
        .background(Color.black.opacity(0.9))
        .clipShape(Capsule())
    }
    .frame(width: UIScreen.main.bounds.width / 1.25)
    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
    .onTapGesture {
      withAnimation { self.show = false }
    }.onAppear(perform: {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation { self.show = false }
      }
    })
  }
}

extension Toast {
  public static func networkError(show: Binding<Bool>) -> Self {
    return Toast(Toast.Model(title: "No network available", image: "wifi.slash"), show: show)
  }
}

public struct ToastModifier: ViewModifier {
  private let toast: Toast
  @Binding private var show: Bool

  public init(toast: Toast, show: Binding<Bool>) {
    self.toast = toast
    self._show = show
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
      if show {
        toast
      }
    }
  }
}

extension View {
  public func toast(toast: Toast, show: Binding<Bool>) -> some View {
    self.modifier(ToastModifier.init(toast: toast, show: show))
  }
}
