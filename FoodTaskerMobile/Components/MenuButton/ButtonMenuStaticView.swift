//
//  ButtonWithImage.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 07.10.2023.
//

import SwiftUI

struct ButtonMenuStaticView: View {
    var status: MenuViewStatic.Status
    var height: CGFloat
    var action: ()->Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .aspectRatio(1/1, contentMode: .fit)
                    .frame(height: height)
                    .foregroundColor(.theme.background)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 5, x: 0, y: 0)
                
                MenuViewStatic(status: status)
                    .frame(width: height/2, height: height/2)
                
            }
        }
        .buttonStyle(NoAnim())
    }
}

struct ButtonMenuStaticView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonMenuStaticView(status: .minus, height: 100, action: {})
    }
}
