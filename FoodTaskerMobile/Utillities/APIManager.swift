//
//  APIManager.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 29.12.2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine

class APIManager {
    static let instance = APIManager()
    
    let baseURL = URL(string: Constants.baseURL)
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    var cancellables = Set<AnyCancellable>()
    
    enum Status: String {
        case success
        case failed
    }
    
    // API - Refresh Token
    func refreshTokenIfNeed(completionHandler: @escaping () -> Void) {
        
        if AuthManager.instance.user?.id == "Anonymous" {
            completionHandler()
            return
        }
        if accessToken.contains("@") {
            completionHandler()
            return
        }
        
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        guard let url = url else { return }
        
        if Date() > self.expired {
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    
                    self.accessToken = jsonData["access_token"].string ?? ""
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int ?? 0))
                    
                    completionHandler()
                    
                case .failure:
                    break
                }
            }
        } else {
            completionHandler()
        }
    }
    
    // API to create an order
    func createOrder(address: String, restaurantId: Int, items: [OrderDetails]) -> (URL?, Data?) {
        let path = "api/customer/order/add/"
        
        let orderDetails = items.map { item in
            return OrderDetailsSerializer(mealId: item.meal.id, quantity: item.quantity)
        }
        
        let order = Order(accessToken: self.accessToken, restaurantId: restaurantId, address: address, orderDetails: orderDetails)
        
        let data = try? JSONEncoder().encode(order)
        let url = baseURL?.appendingPathComponent(path)
        return (url, data)
    }
}

//MARK: - Login section
extension APIManager {
    func sendCode(mail: String, isResetPassword: Bool = false, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        var path = ""
        
        if isResetPassword {
            path = "api/customer/resetPasswordSendCode/\(mail)/"
        } else {
            path = "api/customer/sendCode/\(mail)/"
        }
        
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        NetworkingManager.download(url: url)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(_):                    
                    completionHandler(.failure(StringError("Данной почты не существует!")))
                case .finished: break
                }
            }, receiveValue: { data in
                let jsonData = JSON(data)
                guard
                    let stringStatus = jsonData["status"].string,
                    let status = Status(rawValue: stringStatus)
                else {
                    return
                }
                
                switch status {
                case .success:
                    guard let code = jsonData["code"].int else {
                        return
                    }
                    completionHandler(.success(code))
                case .failed:
                    guard let error = jsonData["error"].string else {
                        return
                    }
                    completionHandler(.failure(StringError(error)))
                }
            })
            .store(in: &self.cancellables)
        
    }
    
    func register(username: String, mail: String, password: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        let path = "api/customer/register/\(username)/\(mail)/\(password)/"
        
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        NetworkingManager.download(url: url)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): completionHandler(.failure(error))
                }
            }, receiveValue: { result in
                completionHandler(.success(true))
            })
            .store(in: &self.cancellables)
        
    }
    
    func deleteAccount(completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let url = deleteAccountURL() else { return }
        
        NetworkingManager.download(url: url)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): completionHandler(.failure(error))
                }
            }, receiveValue: { result in
                
                completionHandler(.success(true))
            })
            .store(in: &self.cancellables)
    }
    
    func login(mail: String, password: String, completionHandler: @escaping (Result<MailUser, Error>) -> Void) {
        let path = "api/customer/login/\(mail)/\(password)/"
        
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        NetworkingManager.download(url: url)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { data in
                let jsonData = JSON(data)
                guard
                    let stringStatus = jsonData["status"].string,
                    let status = Status(rawValue: stringStatus)
                else {
                    return
                }
                
                switch status {
                case .success:
                    let user = jsonData["user"]
                    guard
                        let id = user["id"].int,
                        let username = user["username"].string
                    else {
                        return
                    }
                    let mailUser = MailUser(id: id, username: username)
                    self.accessToken = mail
                    
                    completionHandler(.success(mailUser))
                case .failed:
                    guard  let error = jsonData["error"].string else {
                        return
                    }
                    completionHandler(.failure(StringError(error)))
                }
            })
            .store(in: &self.cancellables)
                
    }

    func login(method: AuthManager.RegistrationMethod, userType: String) async throws -> Void {
        let path = "api/social/convert-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": method == .vk ? Constants.CLIENT_ID_VK : Constants.CLIENT_ID_GOOGLE,
            "backend": method == .vk ? "vk-oauth2" : "google-oauth2",
            "token": AuthManager.instance.token(method: method) ?? "",
            "user_type": userType
        ]
        guard let url = url else { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { [self] response in                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    
                    self.accessToken = jsonData["access_token"].string ?? ""
                    self.refreshToken = jsonData["refresh_token"].string ?? ""
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int ?? 0))
                    continuation.resume(returning: Void())
                    
                case .failure(let error):                    
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // API - Logout
    func logout(_ method: AuthManager.RegistrationMethod, completionHandler: @escaping (Error?) -> Void) {
        let path = "api/social/revoke-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": method == .vk ? Constants.CLIENT_ID_VK : Constants.CLIENT_ID_GOOGLE,
            "token": AuthManager.instance.token(method: method) ?? "",
        ]
        guard let url = url else { return }
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error as Error?)
            }
        }
    }
    
    func resetPassword(mail: String, password: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        let path = "api/customer/resetPassword/\(mail)/\(password)/"
        
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        NetworkingManager.download(url: url)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { data in
                let jsonData = JSON(data)
                guard
                    let stringStatus = jsonData["status"].string,
                    let status = Status(rawValue: stringStatus)
                else {
                    return
                }
                
                switch status {
                case .success:
                    completionHandler(.success(true))
                case .failed:
                    guard  let error = jsonData["error"].string else {
                        return
                    }
                    completionHandler(.failure(StringError(error)))
                }
            })
            .store(in: &self.cancellables)
        
    }
}

//MARK: - Get Data section
extension APIManager {
    // API to fetch all meals of a restaurant
    private func getMeals(completionHandler: @escaping (Result<[Meal], Error>) -> Void) {
        let path = "api/customer/meals/"
        
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        refreshTokenIfNeed {
            NetworkingManager.download(url: url)
                .decode(type: ResponseMeal.self, decoder: JSONDecoder())
                .map { response in response.meals }
                .sink(receiveCompletion: { result in
                    switch result {
                    case .finished: break
                    case .failure(let error): completionHandler(.failure(error))
                    }
                }, receiveValue: { meals in
                    completionHandler(.success(meals))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func getMealsPublisher() -> Future<[Meal], Error> {
        return Future { promise in
            self.getMeals() { result in promise(result) }
        }
    }
    
    // API to fetch all ingredients of a meal
    private func getIngredients(mealId: Int, completionHandler: @escaping (Result<[Ingredient], Error>) -> Void) {
        let path = "api/customer/ingredients/\(mealId)"
        
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        refreshTokenIfNeed {
            NetworkingManager.download(url: url)
                .decode(type: ResponseIngredient.self, decoder: JSONDecoder())
                .map { response in response.ingredients }
                .sink(receiveCompletion: { result in
                    switch result {
                    case .finished: break
                    case .failure(let error): completionHandler(.failure(error))
                    }
                }, receiveValue: { meals in
                    completionHandler(.success(meals))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func getIngredientsPublisher(at mealId: Int) -> Future<[Ingredient], Error> {
        return Future { promise in
            self.getIngredients(mealId: mealId) { result in promise(result) }
        }
    }
    
    // API to get the latest order (Customer)
    func getOrders() -> URL? {
        let path = "api/customer/orders"
        
        return onlyOneAccessToken(at: path)
    }
    
    // API to get the latest order (Customer)
    func getLatestOrder() -> URL? {
        let path = "api/customer/order/latest/"
        
        return onlyOneAccessToken(at: path)
    }
    
    // API to get the latest order's status (Customer)
    func getLatestOrderStatus() -> URL? {
        let path = "api/customer/order/latest_status/"
        
        return onlyOneAccessToken(at: path)
    }
    
    func deleteAccountURL() -> URL? {
        let path = "api/customer/deleteAccount/"
        
        return onlyOneAccessToken(at: path)
    }
    
    private func onlyOneAccessToken(at path: String) -> URL?  {
        let params: [URLQueryItem] = [
            URLQueryItem(name: "access_token", value: self.accessToken)
        ]
        
        let url = baseURL?.appendingPathComponent(path).appending(queryItems: params)
        
        return url
    }
}
