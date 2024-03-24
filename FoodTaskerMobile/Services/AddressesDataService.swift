//
//  AddressesDataService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.11.2023.
//

import Foundation
import CoreData

class AddressesDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "AddressContainer"
    private let entityName = "AddressEntity"
    
    @Published var savedEntities: [AddressEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getAddresses()
        }
    }
    
    //MARK: PUBLIC
    
    func updateAddress(address: Address, status: Status) {
        
        if let entity = savedEntities.first(where: {
            return $0.addressID == address.id }) {
            switch status {
            case .update, .add:
                update(entity: entity, address: address)
            case .delete:
                delete(entity: entity)
            }
        } else {
            add(address: address)
        }
    }
    
    enum Status {
        case update
        case delete
        case add
    }
    
    //MARK: PRIVATE
    
    private func getAddresses() {
        let request = NSFetchRequest<AddressEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Address Entities. \(error)")
        }
        
//        do {
//            try container.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "AddressEntity")))
//            try container.viewContext.save()
//        } catch {
//        }
    }
    
    private func add(address: Address) {
        let entity = AddressEntity(context: container.viewContext)
        entity.addressID = address.id
        entity.street = address.street
        entity.house = address.house
        entity.floor = address.floor
        entity.apartmentNumber = address.apartmentNumber
        entity.intercom = address.intercom
        entity.entrance = address.entrance
        entity.comment = address.comment
        entity.lastUpdateDate = address.lastUpdateDate
        applyChanges()
    }
    
    private func update(entity: AddressEntity, address: Address) {
        entity.street = address.street
        entity.house = address.house
        entity.floor = address.floor
        entity.apartmentNumber = address.apartmentNumber
        entity.intercom = address.intercom
        entity.entrance = address.entrance
        entity.comment = address.comment
        entity.lastUpdateDate = Date.now
        applyChanges()
    }
    
    private func delete(entity: AddressEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getAddresses()
    }
}

