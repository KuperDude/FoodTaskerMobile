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
    static let BASE_URL = "http://192.168.1.236:8000/"
    static let CLIENT_ID = "fIJ0FhOHz6GLA3SG04INvaKkUyTDXst4r4U0tixS"
    
    static let USERTYPE_CUSTOMER = "customer"
    static let USERTYPE_DRIVER = "driver"
    
    static let instance = APIManager()
    
    let baseURL = URL(string: BASE_URL)
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    // API - Login
    func login(userType: String, completionHandler: @escaping (Error?) -> Void) {
        let path = "api/social/convert-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": APIManager.CLIENT_ID,
            "backend": "vk-oauth2",
            "token": AuthService.instance.token ?? "",
            "user_type": userType
        ]
        
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                self.accessToken = jsonData["access_token"].string ?? ""
                self.refreshToken = jsonData["refresh_token"].string ?? ""
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int ?? 0))
                
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error as Error?)
            }
        }
    }
    
    // API - Logout
    func logout(userType: String, completionHandler: @escaping (Error?) -> Void) {
        let path = "api/social/revoke-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": APIManager.CLIENT_ID,
            "token": AuthService.instance.token ?? "",
        ]
        
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(nil)
                
            case .failure(let error):
                completionHandler(error as Error?)
            }
        }
    }
    
    // API - Refresh Token
    func refreshTokenIfNeed(completionHandler: @escaping () -> Void) {
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        if Date() > self.expired {
            AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
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
    
    // API to fetch all restaurants
    private func getRestaurants(completionHandler: @escaping (Result<[Restaurant], Error>) -> Void) {
        let path = "api/customer/restaurants/"
        let url = baseURL?.appendingPathComponent(path)
        
//        refreshTokenIfNeed {
            AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ResponseRestaurant.self, decoder: JSONDecoder()) { response in
                    switch response.result {
                    case .success(let restaurants): completionHandler(.success(restaurants.restaurants))
                    case .failure(let error): completionHandler(.failure(error))
                    }
                }
                
//            AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    let jsonData = JSON(value)
//                    completionHandler(jsonData)
//                    
//                case .failure:
//                    completionHandler(nil)
//                }
//            }
//        }
    }
    
    func getRestaurantsPublisher() -> Future<[Restaurant], Error> {
        return Future { [self] promise in
            getRestaurants { result in promise(result) }
        }
    }
    
    
    
}
