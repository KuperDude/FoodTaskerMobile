//
//  DeliveryProgressAnimatedView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.03.2024.
//

import SwiftUI

struct DeliveryProgressAnimatedView: View {
    
    @State var animate: Bool = false
    var status: DeliveryViewModel.Status
    var currentStatus: DeliveryViewModel.Status
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.theme.green)
                    .frame(height: calculateProgressHeihgt())
                    .animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: true), value: animate)
                    .frame(width: 5)
                    .padding(.leading, 13)
                Spacer()
            }
            Spacer(minLength: 0)
        }
        .frame(height: 30)
    }
    
    func calculateProgressHeihgt() -> CGFloat {
        if currentStatus.priority > status.priority {
            return 30
        } else {
            return 0
        }
    }
}

#Preview {
    DeliveryProgressAnimatedView(status: .delivered, currentStatus: .delivered)
}
