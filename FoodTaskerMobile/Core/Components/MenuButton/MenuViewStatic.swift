//
//  MenuButtonViewStatic.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.11.2023.
//

import SwiftUI

struct MenuViewStatic: View {
    var status: Status
    
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            
            Rectangle() // top
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(status.topDegrees, anchor: status == .plus ? .leading : .trailing)
//                .rotationEffect(.degrees(animateStatus ? 48 : 0), anchor: .leading)
                .foregroundColor(.theme.accent)
                .opacity(status == .minus ? 0 : 1)
            
            Rectangle() // middle
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .scaleEffect(status == .minus ? 1 : 0.001, anchor: .trailing)
                .opacity(status == .minus ? 1 : 0)
                .foregroundColor(.theme.accent)
            
            Rectangle() // bottom
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(status.bottomDegrees, anchor: status == .plus ? .leading : .trailing)
//                .rotationEffect(.degrees(animateStatus ? -48 : 0), anchor: .leading)
                .foregroundColor(.theme.accent)
                .opacity(status == .minus ? 0 : 1)
        }
        .rotationEffect(Angle(degrees: status == .plus ? 45 : 0))
        .scaleEffect(0.6)
    }
    
    enum Status: Equatable {
        case minus
        case chevron
        case plus
        
        var topDegrees: Angle {
            switch self {
            case .minus: return .degrees(0)
            case .plus: return .degrees(48)
            case .chevron: return .degrees(-24)
            }
        }
        
        var bottomDegrees: Angle {
            switch self {
            case .minus: return topDegrees
            case .plus: return -topDegrees
            case .chevron: return -topDegrees
            }
        }
    }
}

struct MenuViewStatic_Previews: PreviewProvider {
    static var previews: some View {
        MenuViewStatic(status: .minus, action: {})
    }
}
