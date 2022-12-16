//
//  RestaurantMealDetails.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 12.12.2022.
//

import SwiftUI

struct RestaurantMealDetails: View {
    var namespace: Namespace.ID
    var id: Int
    
    @State private var quantity = 1
    
    typealias MatchedGeometryId = RestaurantMealCell.MatchedGeometryId
    
    var body: some View {
        VStack {
            
            Image("blank_food")
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(id), in: namespace)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                }
                .padding(.bottom, 5)
            
            Text("Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.theme.accent)
                .padding(.vertical, 10)
                .matchedGeometryEffect(id: MatchedGeometryId.description.rawValue + String(id), in: namespace)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                }
                .padding(.bottom, 5)
            
            HStack {
                Text("Quantity:")
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                    }
                HStack {
                    Button {
                        quantity -= 1
                    } label: {
                        Text("-")
                            .foregroundColor(.theme.accent)
                            .aspectRatio(1/1, contentMode: .fill)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.theme.background)
                                    .shadow(
                                        color: Color.theme.accent.opacity(0.15),
                                        radius: 5, x: 0, y: 0)
                                    .padding(5)
                            }
                    }
                    
                    Text("\(quantity)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.theme.accent)
                    
                    Button {
                        quantity += 1
                    } label: {
                        Text("+")
                            .foregroundColor(.theme.accent)
                            .aspectRatio(1/1, contentMode: .fill)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.theme.background)
                                    .shadow(
                                        color: Color.theme.accent.opacity(0.15),
                                        radius: 5, x: 0, y: 0)
                                    .padding(5)
                            }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                    
                }
                
            }
            .font(.system(size: 20))
            .padding(.bottom, 5)
            
            
            
            HStack {
                Text("Price:")
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                    }
                Text("$12")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.theme.green)
                    .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(id), in: namespace)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                    }
            }
            .font(.system(size: 20))
            .padding(.bottom, 5)
            
            Button {
                quantity += 1
            } label: {
                Text("Add To Cart")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.green.opacity(0.5))
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                    }
            }
            
            
            Spacer()
  
        }
        .padding()
    }
}

struct RestaurantMealDetails_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        RestaurantMealDetails(namespace: namespace, id: 1)
    }
}

