//
//  LoginViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.12.2022.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private var appDelegate: AppDelegate
    var authService: AuthService
    
    @Published var isLoggin = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        self.authService = AuthService.instance
        
        addPublishers()
    }
    
    func addPublishers() {
        authService.$isLoggin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.isLoggin = bool
            }
            .store(in: &cancellables)
    }
}
