//
//  MealDetailHeader.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.11.2024.
//

import SwiftUI
import SwiftfulUI

struct MealDetailHeader: View {
    
    var height: CGFloat = 300
    var title = "Some title meal"
    var subtitle = "Subtitle goes here"
    var imageName = Constants.randomImage
    var shadowColor: Color = .theme.background.opacity(0.8)
    
    
    var body: some View {
        Rectangle()
            .opacity(0)
            .overlay {
                ImageLoaderView(urlString: imageName)
            }
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    Text(subtitle)
                        .font(.headline)
                    
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .foregroundColor(.theme.accent)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [shadowColor.opacity(0), shadowColor],
                        startPoint: .top, endPoint: .bottom
                    )
                )

                , alignment: .bottomLeading
            )
            .asStretchyHeader(startingHeight: height)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ScrollView {
            MealDetailHeader()
        }
        .ignoresSafeArea()
    }
    
}
