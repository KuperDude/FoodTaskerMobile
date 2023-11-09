//
//  AddressView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.10.2023.
//

import SwiftUI

struct AddressView: View {
    
    @State private var gridSize: CGSize = .zero
    @Binding var isOn: Bool
    @Binding var address: Address
    
    var body: some View {
        VStack(spacing: 15) {
            addressText
            
            HStack {
                AddressInputCell(title: "Кв. / офис", text: $address.apartmentNumber)
                    .frame(width: gridSize.width, height: gridSize.height)
                    .background(isOn ? Color.theme.secondaryText.clipShape(RoundedRectangle(cornerRadius: 10)) : Color.clear.clipShape(RoundedRectangle(cornerRadius: 10)))
                    .disabled(isOn ? true : false)
                    
                Spacer()
                
                Text("Нет квартиры\nили офиса")
                    .font(.caption)
                    .fontWidth(.compressed)
                
                Toggle(isOn: $isOn) {
                    EmptyView()
                }
                .labelsHidden()
                .onChange(of: isOn) { newValue in
                    address.apartmentNumber = ""
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
//                HStack(spacing: 10) {
                GeometryReader { geo in
                    AddressInputCell(title: "Подъезд", text: $address.entrance)
                        .frame(height: 60)
                        .preference(key: SizePreferenceKey.self, value: geo.size)
                }
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    gridSize = size
                }
//                }
                
//                HStack(spacing: 10) {
                AddressInputCell(title: "Этаж", text: $address.floor)
                    .frame(height: 60)
//                }
                
//                HStack(spacing: 10) {
                AddressInputCell(title: "Домофон", text: $address.intercom)
                    .frame(height: 60)
//                }
            }
            
            AddressInputCell(title: "Комментарий курьеру", lineLimit: 5, text: $address.comment)
                .frame(height: 120)
            
            
                
//                Spacer()
//
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(lineWidth: 3)
//                    .frame(width: UIScreen.main.bounds.width / 3 - 32 - 20)
//                    .frame(height: 60)
//                    .foregroundColor(.theme.secondaryText)
//
//                Spacer()
//
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(lineWidth: 3)
//                    .frame(width: UIScreen.main.bounds.width / 3 - 32 - 20)
//                    .frame(height: 60)
//                    .foregroundColor(.theme.secondaryText)
//
//            }
        }
        .padding(.horizontal)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(isOn: .constant(false), address: .constant(Address(street: "Ул. Ташкенская", house: "32/156 ст. 1", floor: "", apartamentNumber: "", intercom: "", entrance: "", comment: "")))
    }
}

extension AddressView {
    
    var addressText: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.theme.secondaryText)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(address.isStreetAndHouseFill ? address.street + ", " + address.house : "")
                        .foregroundColor(.theme.accent)
                    Text("Москва")
                        .font(.callout)
                        .fontWidth(.compressed)
                        .foregroundColor(.theme.accent)
                }
                    
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.theme.accent)
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
}
