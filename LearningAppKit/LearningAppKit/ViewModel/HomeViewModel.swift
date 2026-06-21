//
//  HomeViewModel.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation

@Observable
class HomeViewModel {
    // MARK: - Variables
    private var itemRepository: any RepositoryProtocol<Item>
    private var secondItemRepository: any RepositoryProtocol<SecondItem>
    
    private(set) var items: [Item] = []
    private(set) var secondItems: [SecondItem] = []
    
    // MARK: - Init
    init(itemRepository: any RepositoryProtocol<Item>, secondItemRepository: any RepositoryProtocol<SecondItem>) {
        self.itemRepository = itemRepository
        self.secondItemRepository = secondItemRepository
    }
    
    // MARK: - Functions
    
    func load() throws {
        self.items = try itemRepository.getAll()
        self.secondItems = try secondItemRepository.getAll()
    }
    
    func addItem(timeStamp: Date) throws {
        try itemRepository.add(item: Item(timestamp: timeStamp))
        self.items = try itemRepository.getAll()
    }
    
    func addSecondItem(name: String) throws {
        try secondItemRepository.add(item: SecondItem(name: name))
        self.secondItems = try secondItemRepository.getAll()
    }
    
    func removeItem(item: Item) throws {
        try itemRepository.delete(item: item)
        self.items = try itemRepository.getAll()
    }
    
    func removeSecondItem(item: SecondItem) throws {
        try secondItemRepository.delete(item: item)
        self.secondItems = try secondItemRepository.getAll()
    }
    
    func editItem(item: Item, newDate: Date) throws {
        item.timestamp = newDate
        try itemRepository.save()
        self.items = try itemRepository.getAll()
    }
    
    func editSecondItem(secondItem: SecondItem, newName: String) throws {
        secondItem.name = newName
        try secondItemRepository.save()
        self.secondItems = try secondItemRepository.getAll()
    }
}
