//
//  AddNewAdressButton.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.07.2023.
//

import SwiftUI

struct AddNewAddressButton: View {
    
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Добавить новый адресс")
                .font(.title)
                .fontWidth(.compressed)
            Spacer()
        }
        .onTapGesture {
            withAnimation(.linear) {
                onTap()
            }
        }
        .padding(.horizontal)
        .frame(height: 50)
    }
}

struct AddNewAddressButton_Previews: PreviewProvider {
    static var previews: some View {
        AddNewAddressButton(onTap: {})
    }
}
