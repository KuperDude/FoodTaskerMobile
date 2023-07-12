//
//  RestaurantImageService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.12.2022.
//

import Foundation
import SwiftUI
import Combine

class RestaurantImageService {
    
    @Published var image: UIImage?
    
    private var imageSubscription: AnyCancellable?
    private let restaurant: Restaurant
    private let fileManager = LocalFileManager.instance
    private let folderName = "Restaurant_logos"
    private let imageName: String
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self.imageName = String(restaurant.id)
        getRestaurantImage()
    }
    
    private func getRestaurantImage() {

            if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {                
                image = savedImage
            } else {
                Task {
                    await downloadImage()
                }
            }
        
    }
    
    private func downloadImage() async {
        guard let url = URL(string: restaurant.logo) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
        
//        imageSubscription = NetworkingManager.download(url: url)
//            .tryMap({ data -> UIImage? in
//                return UIImage(data: data)
//            })
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedImage in
//                guard let self = self, let downloadImage = returnedImage else { return }
//                self.image = downloadImage
//                self.imageSubscription?.cancel()
//                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
//            }
    }
}

