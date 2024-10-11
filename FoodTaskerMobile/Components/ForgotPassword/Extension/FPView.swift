//
//  FPView.swift
//  LMS_Mobile
//
//  Created by MyBook on 02.07.2024.
//

import SwiftUI

struct OnkeyboardAppearHandler: ViewModifier {
    var handler: (Bool) -> Void
    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    handler(true)
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    handler(false)
                }
            }
    }
}

extension View {
    public func onKeyboardAppear(handler: @escaping (Bool) -> Void) -> some View {
        modifier(OnkeyboardAppearHandler(handler: handler))
    }
    
    func forgotPasswordButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(in: RoundedRectangle(cornerRadius: 10))
            .backgroundStyle(.blue)
            .padding()
    }
}


struct CustomTextField: ViewModifier {

    @Binding var text: String
    @FocusState private var focusedState: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.theme.accent)
            .keyboardType(.default)
            .disableAutocorrection(true)
            .focused($focusedState)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(.theme.accent)
                    .opacity(text.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        focusedState = false
                        text = ""
                    }
                , alignment: .trailing
            )
            .font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.background)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
            )
            .padding()
            .onTapGesture {
                focusedState.toggle()
            }
    }
}

extension View {
    func textFieldStyle(text: Binding<String>) -> some View {
        modifier(CustomTextField(text: text))
    }
}
