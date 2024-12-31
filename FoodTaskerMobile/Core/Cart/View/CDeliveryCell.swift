//
//  DeliveryCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.07.2023.
//

import SwiftUI

struct CDeliveryCell: View {
    @ObservedObject var mainVM: MainViewModel
    var onTap: () -> Void
    
    var body: some View {

        HStack {
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("Доставка")
                        .foregroundColor(.theme.accent)
                        .underline()
                        .font(.title)
                        .fontWidth(.compressed)
                        .overlay {
                            Rectangle()
                                .opacity(0.01)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        onTap()
                                    }
                                }
                        }
                    Spacer()
                    
                    Text(mainVM.address.convertToString())
                    
                    Spacer()
                    HStack {
                        
                        Spacer()
                        
                        Text(mainVM.deliveryPrice.asCurrencyWith2Decimals())
                            .font(.system(size: 18))
                            .foregroundColor(.theme.green)
                    }
                }
                .frame(height: 80)
            }
        }
    }
}

struct CDeliveryCell_Previews: PreviewProvider {
    static var previews: some View {
        CDeliveryCell(mainVM: MainViewModel(), onTap: {})
    }
}


