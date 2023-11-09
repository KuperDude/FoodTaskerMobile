//
//  ButtonWithImage.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 07.10.2023.
//

import SwiftUI

struct ButtonWithImage: View {
    var imageNamed: String
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
                
                Image(systemName: imageNamed)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: height/2, height: height/2)
                    .foregroundColor(.theme.accent)
                
            }
        }
    }
}

struct ButtonWithImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithImage(imageNamed: "", height: 100, action: {})
    }
}
