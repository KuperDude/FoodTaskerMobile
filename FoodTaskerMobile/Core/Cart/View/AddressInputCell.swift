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
                if let lineLimit = lineLimit {
                    TextField("", text: $text, axis: .vertical)
                        .lineLimit(lineLimit)
                        .background(.clear)
                } else {
                    TextField("", text: $text)
                        .background(.clear)
                }
                
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 5)
        }
    }
}

struct AddressInputCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressInputCell(title: "", lineLimit: nil, text: .constant(""))
    }
}
