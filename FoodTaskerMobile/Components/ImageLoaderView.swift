//
//  ImageLoaderView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.09.2024.
//
import SwiftUI
import Kingfisher

struct ImageLoaderView: View {
    
    var urlString = Constants.randomImage
    var resizingMode: SwiftUI.ContentMode = .fit
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                KFImage(URL(string: urlString))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
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
