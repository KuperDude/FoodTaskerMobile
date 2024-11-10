//
//  ImageLoaderView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.09.2024.
//
import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    
    var urlString = Constants.randomImage
    var resizingMode: ContentMode = .fit
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
            
    }
}

#Preview {
    ImageLoaderView()
        .cornerRadius(30)
        .padding()
        .padding(.vertical)
}

#Preview {
    ImageLoaderView()
}
