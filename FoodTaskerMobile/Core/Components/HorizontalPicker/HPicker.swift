//
//  HPicker.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.04.2023.
//

import SwiftUI

struct HPicker: View {
    @Binding var data: [String]
    @Binding var selected: String?
    @Namespace var namespace
    
    var body: some View {
        ScrollViewReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    Spacer()
                    ForEach($data, id: \.self) { value in
                        VStack(spacing: 0) {
                            Text(value.wrappedValue)
                                .overlay(content: {
                                    Rectangle()
                                        .opacity(0.01)
                                        .onTapGesture {
                                            withAnimation {
                                                selected = value.wrappedValue
                                                geometry.scrollTo(value.wrappedValue)
                                            }
                                        }
                                })
                                .font(.title)
                                .fontWidth(.compressed)
                                .id(value.wrappedValue)
                            
                            if selected == value.wrappedValue {
                                Capsule()
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "under_line", in: namespace)
                            } else {
                                Spacer()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct HPicker_Previews: PreviewProvider {
    static var previews: some View {
        HPicker(data: .constant(["Food", "Drink", "Soup", "Free"]), selected: .constant("Food"))
    }
}
