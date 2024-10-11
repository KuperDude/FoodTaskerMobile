//
//  AddressInputCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.10.2023.
//

import SwiftUI

struct AddressInputCell: View {
    let title: String
    @Binding var text: String
    let lineLimit: Int?
    @FocusState var focusedState
    
    init(title: String, lineLimit: Int? = nil, text: Binding<String>) {
        self.title = title
        self.lineLimit = lineLimit
        self._text = text
    }
    
    var body: some View {
        ZStack {
            //background
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(.theme.secondaryText)
            
            //body
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .fontWidth(.compressed)
              
                TextField("", text: $text, axis: lineLimit == nil ? .horizontal : .vertical)
                    .lineLimit(lineLimit == nil ? 1 : lineLimit!)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
                    .focused($focusedState)
                    .background(.clear)
                
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 5)
        }
        .onTapGesture {
            focusedState.toggle()
        }
    }
}

struct AddressInputCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressInputCell(title: "", lineLimit: nil, text: .constant(""))
    }
}
