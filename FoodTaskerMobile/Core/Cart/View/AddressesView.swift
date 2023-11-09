//
//  AddressView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.07.2023.
//

import SwiftUI

struct AddressesView: View {
    
    @State private var tappedButton: Bool = false
    @FocusState private var focused: Bool
    @State private var address = ""
    
    @State private var isButtonPressed = false
    
    var body: some View {
        VStack {
            VStack {
                ScrollView {
                    ForEach(0..<8) { num in
                        AddressCell(number: num)
                    }
                    AddNewAddressButton(onTap: {
                        isButtonPressed = true
                    })
                }
            }
//            .background(content: {
//                Color.red
//            })
            .padding(.vertical)
            .padding(.bottom, 10)
            .fullScreenCover(isPresented: $isButtonPressed) {
                EditMapView(mainVM: MainViewModel())
            }
        }
    }
}

struct AddressesView_Previews: PreviewProvider {
    static var previews: some View {
        AddressesView()
    }
}
