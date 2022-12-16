//
//  ContentView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 04.12.2022.
//

import SwiftUI


struct LoginView: View {
    
    @State private var isPresent = false
    @State private var selectedRole = 1
    
    var body: some View {
        // content
        VStack(spacing: 20) {
            nameApp
            createdBy
            
            Spacer()
            
            VStack(spacing: 35) {
                picker
                loginButton
            }
            .padding(.horizontal, 20)
        }
        .background {
            // background
            backgroundImage
        }
        .fullScreenCover(isPresented: $isPresent) {
            HomeView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView {
    var nameApp: some View {
        Text("FoodTasker")
            .font(.custom("Avenir Next", size: 49))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 135)
    }
    
    var createdBy: some View {
        Text("created by Greg Fields")
            .foregroundColor(Color.init(uiColor: .lightGray))
    }
    
    var picker: some View {
        Picker("role", selection: $selectedRole) {
            Text("Customer").tag(0)
            Text("Driver").tag(1)
        }
        .background(content: {
            Color.white
        })
        .pickerStyle(.segmented)
    }
    
    var loginButton: some View {
        Button {
            isPresent.toggle()
        } label: {
            Text("Login with VK")
                .font(.system(size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background {
                    Color.theme.green
                }
                .padding(.bottom, 50)
        }
    }
    
    var backgroundImage: some View {
        Image("background_img")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
    }
}
