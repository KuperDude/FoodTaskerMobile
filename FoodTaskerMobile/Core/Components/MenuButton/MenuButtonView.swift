//
//  MenuButtonView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.12.2022.
//

import SwiftUI

struct MenuButtonView: View {
    @ObservedObject var mainVM: MainViewModel
    
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            
            Rectangle() // top
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(mainVM.animateStatus.topDegrees, anchor: mainVM.animateStatus == .cross ? .leading : .trailing)
//                .rotationEffect(.degrees(animateStatus ? 48 : 0), anchor: .leading)
                .foregroundColor(.theme.accent)
            
            Rectangle() // middle
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .scaleEffect(mainVM.animateStatus == .burger ? 1 : 0.001, anchor: .trailing)
                .opacity(mainVM.animateStatus == .burger ? 1 : 0)
                .foregroundColor(.theme.accent)
            
            Rectangle() // bottom
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(mainVM.animateStatus.bottomDegrees, anchor: mainVM.animateStatus == .cross ? .leading : .trailing)
//                .rotationEffect(.degrees(animateStatus ? -48 : 0), anchor: .leading)
                .foregroundColor(.theme.accent)
        }
        .animation(Animation.interpolatingSpring(stiffness: 300, damping: 15), value: mainVM.animateStatus)
        .onTapGesture {
            action()
            withAnimation {
                mainVM.animateStatus.newStatusOnTap()
            }
        }
        .scaleEffect(0.6)
    }
    
}

struct MenuButtonView_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        MenuButtonView(mainVM: mainVM) { }
    }
}
