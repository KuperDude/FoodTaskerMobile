//
//  RestaurantMenuCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.12.2022.
//

import SwiftUI

struct RestaurantMealCell: View {
    var namespace: Namespace.ID
    var id: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            
            HStack {
                VStack {
                    Text("Meal" + String(id))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.theme.accent)
                        .matchedGeometryEffect(id: MatchedGeometryId.title.rawValue + String(id), in: namespace)
                        
                    Text("Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .foregroundColor(.theme.secondaryText)
                        .padding(.vertical, 10)
                        .matchedGeometryEffect(id: MatchedGeometryId.description.rawValue + String(id), in: namespace)
                    
                    Text("$12")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18))
                        .foregroundColor(.theme.green)
                        .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(id), in: namespace)
                }
                
                Spacer()
                
                    Image("blank_food")
                        .resizable()
                        .padding()
                        .frame(width: 150, height: 150)
                        .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(id), in: namespace)
                    
            }
            .padding()
        }
        .frame(height: 160)
    }
}

struct RestaurantMenuCell_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        RestaurantMealCell(namespace: namespace, id: 1)
    }
}

extension RestaurantMealCell {
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
