//
//  CartCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.12.2022.
//

import SwiftUI

struct CartCell: View {
    var orderDetails: OrderDetails
    @ObservedObject var vm: CartCellViewModel
    var onTap: () -> Void
    
    init(mainVM: MainViewModel, orderDetails: OrderDetails, onTap: @escaping () -> Void) {
        self.orderDetails = orderDetails
        self._vm = ObservedObject(initialValue: CartCellViewModel(mainVM: mainVM, orderDelails: orderDetails))
        self.onTap = onTap
    }
    
    var body: some View {

        HStack {
            ImageLoaderView(urlString: orderDetails.meal.image, resizingMode: .fit)
                .frame(width: 100, height: 100)
                .scaledToFill()
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("\(orderDetails.meal.name)")
                        .foregroundColor(.theme.accent)
                        .underline()
                        .font(.title)
                        .fontWidth(.compressed)
                        .overlay {
                            Rectangle()
                                .opacity(0.01)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        onTap()
                                    }
                                }
                        }
                    Spacer()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(orderDetails.ingredients.filter({ !$0.isAdd })) { ingredient in
                                Text(ingredient.name)
                                    .foregroundColor(.red)
                                    .strikethrough()
                            }
                        }
                    }
                    
                    Spacer()
                    HStack {
                        stepper
                        
                        Spacer()
                        
                        Text(orderDetails.subTotal.asCurrencyWith2Decimals())
                            .font(.system(size: 18))
                            .foregroundColor(.theme.green)
                    }
                }
                .frame(height: 120)
            }
        }
    }
}

struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        CartCell(mainVM: MainViewModel(), orderDetails: OrderDetails(meal: Meal(id: 1, name: "Burger", shortDescription: "", image: "", price: 0, category: .init(id: 123, name: "lol")), ingredients: [Ingredient(id: 12, name: "Solt", image: "")], quantity: 99, id: UUID()), onTap: { })
    }
}

extension CartCell {
    
    var stepper: some View {
        HStack {
            Button {
                vm.change(quantity: orderDetails.quantity - 1)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.theme.secondaryText)
                        .opacity(0.3)
                    Image(systemName: "minus")
                        .foregroundColor(.theme.accent)
                }
            }
            .buttonStyle(NoAnim())
            
            Spacer()
            
            Text("\(orderDetails.quantity)")
                .fontWeight(.medium)
                
            Spacer()
            
            Button {
                if orderDetails.quantity != 99 {
                    vm.change(quantity: orderDetails.quantity + 1)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.theme.secondaryText)
                        .opacity(0.3)
                    Image(systemName: "plus")
                        .foregroundColor(.theme.accent)
                }
            }
            .buttonStyle(NoAnim())
            .opacity(orderDetails.quantity == 99 ? 0.3 : 1)
            
        }
        .frame(width: 100)
    }
}
