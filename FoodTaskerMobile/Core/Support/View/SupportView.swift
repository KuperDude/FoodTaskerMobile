//
//  SupportView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.01.2025.
//

import SwiftUI

struct SupportView: View {
    @ObservedObject var mainVM: MainViewModel
    let phoneNumber = "+7 7777 777 777"
    
    init(mainVM: MainViewModel) {
        self.mainVM = mainVM
    }
    
    var body: some View {
        ZStack {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            VStack {
                HStack {
                    MenuButtonView(mainVM: mainVM)
                    
                    Spacer()
                }
                
                Text(phoneNumber)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.theme.accent)
                    .underline()
                    .onTapGesture {
                        if let url = URL(string: "tel:\(phoneNumber)"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }

                Spacer()
            }
        }
    }
}

#Preview {
    SupportView(mainVM: MainViewModel())
}
