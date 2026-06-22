//
//  HomeViewModel.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import AppKit
// Para pegar teclas do macOS.
import Carbon.HIToolbox

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
    var apps: [URL] = []
    var permission: Bool = false
    
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
    
    // Para listagem de apps
    func returnIcon(url: String) -> NSImage {
        return NSWorkspace.shared.icon(forFile: url)
    }
    
    func returnName(url: String) -> String {
        return FileManager.default.displayName(atPath: url)
    }
    
    // Para abrir os apps (fecha os outros)
    func openApps() async throws {
        
        for app in apps {
            NSWorkspace.shared.open(app.absoluteURL)
        }
        let manter = Set(apps.compactMap { Bundle(url: $0)?.bundleIdentifier })
        let paraFechar = appsParaFechar(manter: manter)
        
        try await Task.sleep(for: .milliseconds(800))
        
        for app in paraFechar {
            app.activate()
            try await Task.sleep(for: .milliseconds(200))
            try await simulateCMDQ(app: app)
        }
    }
    
    private func appsParaFechar(manter bundleIDsManter: Set<String>) -> [NSRunningApplication] {
        let meuBundleID = Bundle.main.bundleIdentifier ?? ""

        // Esse filtro pega todos os apps rodando, menos os que passarem em false.
        // Se algum app cair na condição de false, ele não entra na lista, e o filter corta isso.
        return NSWorkspace.shared.runningApplications.filter { app in
            // só apps com janela visível (ignora agentes, daemons, Dock, Finder, etc.)
            guard app.activationPolicy == .regular else { return false }
            // Pega o bundle ID do app.
            guard let bundleID = app.bundleIdentifier else { return false }
            // não fecha o próprio app
            guard bundleID != meuBundleID else { return false }
            // não fecha quem está na lista pra manter aberto
            guard !bundleIDsManter.contains(bundleID) else { return false }
            return true
        }
    }
    
    private func simulateCMDQ(app: NSRunningApplication) async throws {
        // Coloca o app em foco
        app.activate()
        
        // Espera um pouco
        try await Task.sleep(for: .milliseconds(200))
        
        // Cria uma fonte de evento
        // No mac temos várias filas de eventos, hardware, software..
        // com event source, eu defino de onde o contexto vem
        // HID = hardware, Combined = estado atual, software + hardware, private = fila independente
        let src = CGEventSource(stateID: .hidSystemState)
        let keyQ = CGKeyCode(kVK_ANSI_Q)
        
        let down = CGEvent(keyboardEventSource: src, virtualKey: keyQ, keyDown: true)
        down?.flags = .maskCommand
        down?.postToPid(app.processIdentifier)
        
        let up = CGEvent(keyboardEventSource: src, virtualKey: keyQ, keyDown: false)
        up?.flags = .maskCommand
        up?.postToPid(app.processIdentifier)
    }
}
