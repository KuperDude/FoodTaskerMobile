//
//  MealImageService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 02.01.2023.
//

import Foundation
import SwiftUI
import Combine

class MealImageService {
    
    @Published var image: UIImage?
    
    private var imageSubscription: AnyCancellable?
    private let meal: Meal
    private let fileManager = LocalFileManager.instance
    private let folderName = "Meal_images"
    private let imageName: String
    
    init(meal: Meal) {
        self.meal = meal
        self.imageName = String(meal.id)
        getRestaurantImage()
    }
    
    private func getRestaurantImage() {
        
            if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
                image = savedImage
            } else {
                Task {
                    await downloadMealImage()
                }
            }
        
    }
    
    private func downloadMealImage() async {
        guard let url = URL(string: meal.image) else { return }
        
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


