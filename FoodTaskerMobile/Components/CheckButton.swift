//
//  CheckButton.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.06.2023.
//

import SwiftUI

struct CheckButton: View {
    @Binding var isCheck: Bool
    
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 50) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 10)
                
                Rectangle()
                    .frame(width: isCheck ? 40 : 100, height: 10)
                    .cornerRadius(4)
                    .rotationEffect(Angle(degrees: isCheck ? 60 : 45), anchor: isCheck ? .trailing : .center)
                    .frame(width: isCheck ? 80 : 100, height: isCheck ? 70 : 100, alignment: isCheck ? .bottomLeading : .center)
                
                Rectangle()
                    .frame(width: 10, height: isCheck ? 80 : 100)
                    .cornerRadius(4)
                    .rotationEffect(Angle(degrees: isCheck ? 29 : 45), anchor: isCheck ? .top : .center)
                    .frame(width: isCheck ? 80 : 100, alignment: isCheck ? .trailing : .center)
                
            }
            .foregroundColor(isCheck ? .theme.green : .theme.red)
            .frame(width: 100, height: 100)
            .onTapGesture {
                action()
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 15)) {
                    isCheck.toggle()
                }
            }
        }
    }
}

struct CheckButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckButton(isCheck: .constant(false), action: {})
    }
}
