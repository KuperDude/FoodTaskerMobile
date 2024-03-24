//
//  IngredientImageService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.06.2023.
//

import Foundation
import SwiftUI
import Combine

class IngredientImageService {
    
    @Published var image: UIImage?
    
    private var imageSubscription: AnyCancellable?
    private let ingredient: Ingredient
    private let fileManager = LocalFileManager.instance
    private let folderName = "Ingredient_images"
    private let imageName: String
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        self.imageName = String(ingredient.id)
        getIngredientImage()
    }
    
    private func getIngredientImage() {
        
            if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
                image = savedImage
            } else {
                Task {
                    await downloadMealImage()
                }
            }
        
    }
    
    private func downloadMealImage() async {
        guard let url = URL(string: ingredient.image) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
            
            guard let downloadImage = image else { return }
                    
            fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
        } catch {
            print(error.localizedDescription)
        }
    }
}


