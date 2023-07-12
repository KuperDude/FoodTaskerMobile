//
//  MealCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.12.2022.
//

import SwiftUI

struct MealCell: View {
    var namespace: Namespace.ID
    var meal: Meal
    
    @ObservedObject var vm: MealCellViewModel
    
    init(namespace: Namespace.ID, meal: Meal) {
        self.namespace = namespace
        self.meal = meal
        self._vm = ObservedObject(initialValue: MealCellViewModel(meal: meal))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            HStack {
                VStack {
                    Text(meal.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.theme.accent)
                        .matchedGeometryEffect(id: MatchedGeometryId.title.rawValue + String(meal.id), in: namespace)
                        
                    Text(meal.shortDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .foregroundColor(.theme.secondaryText)
                        .padding(.vertical, 10)
                        .matchedGeometryEffect(id: MatchedGeometryId.description.rawValue + String(meal.id), in: namespace)
                    
                    Text("$\(meal.price.asNumberString())")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18))
                        .foregroundColor(.theme.green)
                        .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(meal.id), in: namespace)
                }
                
                Spacer()
                
                Image(uiImage: vm.image ?? UIImage())
                        .resizable()
                        .padding()
                        .overlay(content: {
                            if vm.isLoading {
                                ProgressView()
                            }
                        })
                        .frame(width: 150, height: 150)
                        .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
                
//                if let image = vm.image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .padding()
//                        .frame(width: 150, height: 150)
//                        .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
//                } else if vm.isLoading {
//                    ProgressView()
//                        .frame(width: 150, height: 150)
//                        .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
//                } else {
//                    Image("blank_food")
//                        .resizable()
//                        .padding()
//                        .frame(width: 150, height: 150)
//                        .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
//                }
                    
            }
            .padding()
        }
        .frame(height: 160)
    }
}

//struct MealCell_Previews: PreviewProvider {
//    @Namespace static var namespace
//    static var previews: some View {
//        MealCell(namespace: namespace, meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: "Food"))
//    }
//}

extension MealCell {
    enum MatchedGeometryId: String, Identifiable {
        case title
        case description
        case image
        case cost
        case background
        
        var id: String {
            self.rawValue
        }
    }
}
