//
//  View.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 30.12.2022.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct BottomSheet: ViewModifier {
    
    @Binding var bottomSheetShown: Bool
    
    let maxHeight: CGFloat?
    let minHeight: CGFloat?
    let offsetY: CGFloat
    let isAllowPresent: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            Color.black
                .opacity(bottomSheetShown ? 0.5 : 0)
                .ignoresSafeArea()
//            GeometryReader { geometry in
//                content
//                    .onAppear {
//                        print(geometry.size.height)
//                    }
//            }
            
            GeometryReader { geometry in
                BottomSheetView(
                    isOpen: self.$bottomSheetShown,
                    maxHeight: (maxHeight == nil ? geometry.size.height * 0.8 : maxHeight)!,
                    minHeight: minHeight,
                    offsetY: offsetY,
                    isAllowPresent: isAllowPresent
                ) {
                    content
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

extension View {
    func presentAsBottomSheet(_ present: Binding<Bool>, maxHeight: CGFloat? = nil, minHeight: CGFloat? = nil, offsetY: CGFloat = .zero, isAllowPresent: Bool = true) -> some View {
        modifier(BottomSheet(bottomSheetShown: present, maxHeight: maxHeight, minHeight: minHeight, offsetY: offsetY, isAllowPresent: isAllowPresent))
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

//struct SizeModifier: ViewModifier {
//    private var sizeView: some View {
//        GeometryReader { geometry in
//            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
//        }
//    }
//
//    func body(content: Content) -> some View {
//        content.background(sizeView)
//    }
//}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
//struct Badge: ViewModifier {
//    var count: Int
//    func body(content: Content) -> some View {
//        content
//            .overlay(alignment: .bottomTrailing) {
//                GeometryReader { geometry in
//                    ZStack {
//                        Circle()
//                            .fill(Color.theme.red)
//                        
//                        Text("\(count)")
//                            .foregroundColor(.theme.accent)
//                    }
//                    .frame(width: min(geometry.size.width, geometry.size.height) / 3, height: min(geometry.size.width, geometry.size.height) / 3, alignment: .bottomTrailing)
//                }
//            }
//    }
//}
//
//extension View {
//    func badge(count: Int) -> some View {
//        modifier(Badge(count: count))
//    }
//}
struct CustomTextField: ViewModifier {

    @Binding var text: String
    @FocusState private var focusedState: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.theme.accent)
            .disableAutocorrection(true)
            .keyboardType(.alphabet)
            .focused($focusedState)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(.theme.accent)
                    .opacity(text.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        focusedState = false
//                            UIApplication.shared.endEditing()
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
}
