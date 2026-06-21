//
//  HomeViewModel.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation

// MARK: - ViewModel
// Para seguir arquitetura MVVM, uso uma viewModel para aprender como integrar esse
// repository genérico dentro de uma viewModel, assim a view só trata as funções.
// como usamos protocolos, nossa viewModel conhece somente o protocolo, mantendo a DI (injeção de dependência).
@Observable
class HomeViewModel {
    // MARK: - Variables
    
    // Algo legal, é que como nosso protocolo também tem <Model: PersistentModel>, podemos definir qual entidade cada repository vai tratar
    // sem que a viewModel conheca o tipo concreto.
    private var itemRepository: any RepositoryProtocol<Item>
    private var secondItemRepository: any RepositoryProtocol<SecondItem>
    
    // Variáveis para a view.
    private(set) var items: [Item] = []
    private(set) var secondItems: [SecondItem] = []
    
    // MARK: - Init
    // OBS: Precisamos usar ANY, se não o compilador da warning, falando que sem, vai parar de funcionar no futuro.
    init(itemRepository: any RepositoryProtocol<Item>, secondItemRepository: any RepositoryProtocol<SecondItem>) {
        self.itemRepository = itemRepository
        self.secondItemRepository = secondItemRepository
    }
    
    // MARK: - Functions
    
    // Carrega os itens, para mantermos somente uma fonte da verdade.
    func load() throws {
        self.items = try itemRepository.getAll()
        self.secondItems = try secondItemRepository.getAll()
    }
    
    // Adiciona no banco e puxa as entidades
    func addItem(timeStamp: Date) throws {
        try itemRepository.add(item: Item(timestamp: timeStamp))
        self.items = try itemRepository.getAll()
    }
    
    // Adiciona no banco e puxa as entidades
    func addSecondItem(name: String) throws {
        try secondItemRepository.add(item: SecondItem(name: name))
        self.secondItems = try secondItemRepository.getAll()
    }
    
    // Remove do banco e puxa as entidades
    func removeItem(item: Item) throws {
        try itemRepository.delete(item: item)
        self.items = try itemRepository.getAll()
    }
    
    // Remove do banco e puxa as entidades
    func removeSecondItem(item: SecondItem) throws {
        try secondItemRepository.delete(item: item)
        self.secondItems = try secondItemRepository.getAll()
    }
    
    // Agora vamo explicar isso aqui
    // Talvez você tenha visto que nosso Repository genérico não tem edit
    // isso se dá por causa que podemos alterar um item salvo no banco diretamente e usar save
    // e o swiftData faz o resto.
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
