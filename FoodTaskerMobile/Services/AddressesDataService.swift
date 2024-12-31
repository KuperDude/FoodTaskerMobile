//
//  AddressesDataService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.11.2023.
//

import Foundation

@MainActor
class AddressesDataService: ObservableObject {
    @Published var addresses: [Address] = []
    private let baseURL = URL(string: Constants.baseURL)
    
    init() {        
        Task {
            await fetchAddresses()
        }
    }
    
    //MARK: PUBLIC
    
    func updateAddress(address: Address, status: Status) async {
        
        if let index = addresses.firstIndex(where: {
            return $0.id == address.id }) {
            switch status {
            case .update, .add:
                addresses[index] = address
                await update(address)
            case .delete:
                addresses.remove(at: index)
                guard let id = address.id else { return }
                await delete(id)
            }
        } else {
            addresses.append(address)
            let result = await add(address)
            
            switch result {
            case .success(let success):
                guard let index = addresses.firstIndex(where: { $0.id == nil }) else { return }
                addresses[index] = address.changeID(success.addressId)
            case .failure(_):
                break
            }
        }
    }
    
    enum Status {
        case update
        case delete
        case add
    }
    
    //MARK: PRIVATE
    
    func fetchAddresses() async {
        let path = "customer/addresses/"
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIManager.instance.accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode(AddressResponse.self, from: data)
            addresses = decodedData.addresses
        } catch {
            print("Error fetching addresses: \(error)")
        }
    }
    
    func add(_ address: Address) async -> Result<AddAddressResponse, Error> {
        let path = "customer/addresses/add/"
        guard let url = baseURL?.appendingPathComponent(path) else { return .failure(URLError(.badURL)) }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(APIManager.instance.accessToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONEncoder().encode(address)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Проверка на успешный статус-код
            guard (response as? HTTPURLResponse)?.statusCode == 201 else {
                return .failure(NSError(domain: "Invalid response", code: 400, userInfo: nil))
            }
            
            // Декодируем ответ
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(AddAddressResponse.self, from: data)
            return .success(responseData)
            
        } catch {
            return .failure(error)
        }
    }

    func update(_ address: Address) async {
        guard let id = address.id else { return }
        let path = "customer/address/\(id)/edit/"
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(APIManager.instance.accessToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONEncoder().encode(address)
            
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            print("Error updating address: \(error)")
        }
    }

    func delete(_ id: Int) async {
        let path = "customer/address/\(id)/delete/"
        guard let url = baseURL?.appendingPathComponent(path) else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("Bearer \(APIManager.instance.accessToken)", forHTTPHeaderField: "Authorization")
            
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            print("Error deleting address: \(error)")
        }
    }
}
