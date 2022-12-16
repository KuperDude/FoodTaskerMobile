//
//  MenuButtonView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.12.2022.
//

import SwiftUI

struct MenuButtonView: View {
    
    @Binding var animateStatus: Status
    
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            
            Rectangle() // top
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(animateStatus.topDegrees, anchor: animateStatus == .chevron ?  .trailing : .leading)
//                .rotationEffect(.degrees(animateStatus ? 48 : 0), anchor: .leading)
                .foregroundColor(.theme.accent)
            
            Rectangle() // middle
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .scaleEffect(animateStatus == .burger ? 1 : 0.001, anchor: .trailing)
                .opacity(animateStatus == .burger ? 1 : 0)
                .foregroundColor(.theme.accent)
            
            Rectangle() // bottom
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(animateStatus.bottomDegrees, anchor: animateStatus == .chevron ? .trailing : .leading)
//                .rotationEffect(.degrees(animateStatus ? -48 : 0), anchor: .leading)
                .foregroundColor(.theme.accent)
        }
        .animation(Animation.interpolatingSpring(stiffness: 300, damping: 15), value: animateStatus)
        .onTapGesture {
            withAnimation {
                newStatusOnTap()
            }
            action()
        }
        .scaleEffect(0.5)
    }
    
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(animateStatus: .constant(.burger)) { }
    }
}

extension MenuButtonView {
    enum Status: Equatable {
        case burger
        case cross(CrossStatus)
        case chevron
        
        var topDegrees: Angle {
            switch self {
            case .burger: return .degrees(0)
            case .cross: return .degrees(48)
            case .chevron: return .degrees(-24)
            }
        }
        
        var bottomDegrees: Angle {
            switch self {
            case .burger: return topDegrees
            case .cross: return -topDegrees
            case .chevron: return -topDegrees
            }
        }
        
        enum CrossStatus: Equatable {
            case leftMenu
            case mealDetails(id: Int)
        }
        
        var getCrossIdOrMinusOne: Int {
            switch self {
            case .cross(.mealDetails(id: let id)): return id
            default: return -1
            }
        }
    }
}

// MARK: - Functions
extension MenuButtonView {
    func newStatusOnTap() {
        switch animateStatus {
        case .burger:                     animateStatus = .cross(.leftMenu)
        case .cross(.leftMenu):           animateStatus = .burger
        case .cross(.mealDetails(id: _)): animateStatus = .chevron
        case .chevron:                    animateStatus = .burger
        }
    }
}
