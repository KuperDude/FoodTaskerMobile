//
//  DeliveryView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 17.12.2022.
//

import SwiftUI
import MapKit

struct DeliveryView: View {
    @Binding var animateMenuButtonStatus: MenuButtonView.Status
    var deliveryStatus = ["Order accepted", "Food ready", "Courier is on the way"]
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
                }

                VStack {
                    ForEach(deliveryStatus, id: \.self) { text in
                        DeliveryCell(text: text)
                    }
                }
                .padding()
                .padding(.leading, 40)
                
                ZStack {
                    // background
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
                        .ignoresSafeArea()
                    
                    //content
                    VStack {
                        Spacer()
                        
                        CourierView()
                            .padding()
                            .padding(.bottom, 20)
                    }
                }

            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView(animateMenuButtonStatus: .constant(.burger))
    }
}
