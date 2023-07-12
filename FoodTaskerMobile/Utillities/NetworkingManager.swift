//
//  NetworkingManager.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.12.2022.
//

import SwiftUI
import Combine
import Alamofire

actor NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url): return "[🔥] Bad response from URL. \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            return .success(data)
//        } catch {
//            return .failure(NetworkingError.badURLResponse(url: url))
//        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func send(url: URL, data: Data) async {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = data
        
//        let str = "{\"order_details\":[{\"meal_id\":6,\"quantity\":1}],\"restaurant_id\":1,\"access_token\":\"FUJMNpU77OyuLiohOl5wzRQkGpHleV\",\"address\":\"13\"}"
//        
//
//        let json: [String: Any] = [
//            "order_details": ["meal_id":"6", "quantity":"1"],
//            "restaurant_id": "1",
//            "access_token": "FUJMNpU77OyuLiohOl5wzRQkGpHleV",
//            "address": "13"
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        print(String(data: jsonData ?? Data(), encoding: .utf8))
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<300 ~= statusCode else {                
                throw URLError(.badURL)
            }
        } catch {
            print(error)
        }
    }
    
    static private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
        }
    }
}

