//
//  SegmentCodeTextFields.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.02.2024.
//

import SwiftUI

struct SegmentCodeTextFields: View {
    
    var char: Character
    
    init(_ char: Character) {
        self.char = char
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(lineWidth: 2)
                .frame(width: 30, height: 40)
                .shadow(
                    color: Color.theme.accent.opacity(1),
                    radius: 10, x: 0, y: 0)
            
            Text(String(char))
        }
        
    }
}

#Preview {
    SegmentCodeTextFields("1")
}
