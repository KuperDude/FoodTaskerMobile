//
//  CodeTextFields.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.02.2024.
//

import SwiftUI

struct CodeTextFields: View {
    @Binding var code: String
    
    @FocusState private var focusedState: Bool
    
    var body: some View {
        HStack {
            
            TextField("", text: $code)
                .foregroundColor(.theme.accent)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
                .focused($focusedState)
                .opacity(0.01)
                .overlay {
                    HStack {
                        ForEach(0..<6) { index in
                            SegmentCodeTextFields(code.count > index ? Array(code)[index] : Character(" "))
                            if index == 2 {
                                Text("-")
                            }
                        }
                    }
                }
        }
        .font(.headline)
        .padding(32)
        .onTapGesture {
            focusedState.toggle()
        }
        .onChange(of: code) { code in
            if code.count >= 6 {
                focusedState = false
            }
            if code.count >= 7 {
                self.code = code[0...5]
            }
        }
    }
}


#Preview {
    CodeTextFields(code: .constant("123"))
}
