//
//  CartView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.12.2022.
//

import SwiftUI
import MapKit

struct CartView: View {
    @State private var address = ""
    @Binding var animateMenuButtonStatus: MenuButtonView.Status
    @State var isShowPayment = false
    
    var body: some View {
        ZStack {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            VStack {
                HStack {
                    MenuButtonView(animateStatus: $animateMenuButtonStatus) {}
                    
                    Spacer()
                    
                    Button("Go to payment") {
                        isShowPayment = true
                    }
                }
                
                if !isShowPayment {
                    VStack {
                        ForEach(0..<3) { _ in
                            CartCell()
                            Divider()
                        }
                        HStack {
                            Text("Total:")
                                .foregroundColor(.theme.accent)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Text("$12")
                                .font(.system(size: 18))
                                .foregroundColor(.theme.green)
                                .padding()
                        }
                        
                        HStack {
                            Text("Address:")
                                .foregroundColor(.theme.accent)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            TextField("Enter your address...", text: $address)
                        }
                    }
                    .padding()
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
                        .ignoresSafeArea()
                } else {
                    CartPaymentView()
                }
                
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(animateMenuButtonStatus: .constant(.burger))
    }
}
