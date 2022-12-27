//
//  CourierView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 17.12.2022.
//

import SwiftUI

struct CourierView: View {
    var body: some View {
        ZStack {
            //background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            //content
            HStack(spacing: 20) {
                Image("courier_exmp")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bob Smidth")
                        .foregroundColor(.theme.accent)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    
                    Text("Car model - Plate Number")
                        .foregroundColor(.theme.secondaryText)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(20)
                
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
    }
}

struct CourierView_Previews: PreviewProvider {
    static var previews: some View {
        CourierView()
    }
}
