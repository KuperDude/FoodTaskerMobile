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
                .rotationEffect(status.topDegrees, anchor: .trailing)
                .foregroundColor(.theme.accent)
                .opacity(status == .chevron ? 1 : 0)
            ZStack {
                Rectangle() // middle
                    .frame(width: 64, height: 10)
                    .cornerRadius(4)
                    .scaleEffect(status == .chevron ? 0.001 : 1, anchor: .trailing)
                    .opacity(status == .chevron ? 0 : 1)
                    .foregroundColor(.theme.accent)
                
                if status == .plus || status == .cross {
                    Rectangle() // middle
                        .frame(width: 64, height: 10)
                        .cornerRadius(4)
                        .scaleEffect(status == .chevron ? 0.001 : 1, anchor: .trailing)
                        .opacity(status == .chevron ? 0 : 1)
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundColor(.theme.accent)
                }
            }
            
            Rectangle() // bottom
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(status.bottomDegrees, anchor: .trailing)
                .foregroundColor(.theme.accent)
                .opacity(status == .chevron ? 1 : 0)
        }
        .scaleEffect(0.5)
        .rotationEffect(Angle(degrees: status == .cross ? 45 : 0))
    }
    
    enum Status: Equatable {
        case minus
        case chevron
        case plus
        case cross
        
        var topDegrees: Angle {
            switch self {
            case .minus: return .degrees(0)
            case .plus: return .degrees(45)
            case .cross: return .degrees(45)
            case .chevron: return .degrees(-24)
            }
        }
        
        var bottomDegrees: Angle {
            switch self {
            case .minus: return topDegrees
            case .plus: return -topDegrees
            case .cross: return -topDegrees
            case .chevron: return -topDegrees
            }
        }
    }
}

struct MenuViewStatic_Previews: PreviewProvider {
    static var previews: some View {
        MenuViewStatic(status: .minus)
    }
}
