//
//  AdressCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.07.2023.
//

import SwiftUI

struct AddressCell: View {
    @Binding var mainAddress: Address
    var address: Address
    var settingsAction: ()->Void
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Group {
                        Image(systemName: address.id == mainAddress.id ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text(address.isStreetAndHouseFill ? address.street + ", " + address.house : "")
                            .font(.title)
                            .fontWidth(.compressed)
                    }
                    .onTapGesture {
                        mainAddress = address
                    }
                    
                    Spacer()
                    Button {
                        settingsAction()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal)
                .frame(height: 50)
                Divider()
            }
        }
    }
}

struct AdressCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressCell(mainAddress: .constant(Address()), address: Address(), settingsAction: {})
    }
}
