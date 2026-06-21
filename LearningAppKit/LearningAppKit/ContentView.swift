//
//  ContentView.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // MARK: - Variables
    
    // Variáveis de ambiente (banco e fechar alerta/modais)
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Nossa viewModel
    @State var viewModel: HomeViewModel
    
    // Tratamento de erro
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    // MARK: - Body View
    var body: some View {
        VStack {
            // Usamos duas listas, em horizontal, uma com o primeiro
            // objeto, outra com o segundo, para testarmos o CRUD
            // do nosso Repository.
            HStack {
                List(viewModel.items) { item in
                    Text(item.timestamp.description)
                    // No iphone é swipeActions, aqui é contextMenu
                        .contextMenu {
                            Button(action: {
                                do {
                                    try viewModel.editItem(item: item, newDate: Date())
                                } catch {
                                    showError = true
                                    errorMessage = error.localizedDescription
                                }
                            }, label: {
                                Image(systemName: "pencil")
                            })
                            Button(action: {
                                do {
                                    try viewModel.removeItem(item: item)
                                } catch {
                                    showError = true
                                    errorMessage = error.localizedDescription
                                }
                            }, label: {
                                Image(systemName: "xmark")
                            })
                        }
                }
                List(viewModel.secondItems) { seconditem in
                    Text(seconditem.name)
                        .contextMenu {
                            Button(action: {
                                do {
                                    try viewModel.editSecondItem(secondItem: seconditem, newName: "AnotherTest")
                                } catch {
                                    showError = true
                                    errorMessage = error.localizedDescription
                                }
                            }, label: {
                                Image(systemName: "pencil")
                            })
                            Button(action: {
                                do {
                                    try viewModel.removeSecondItem(item: seconditem)
                                } catch {
                                    showError = true
                                    errorMessage = error.localizedDescription
                                }
                            }, label: {
                                Image(systemName: "xmark")
                            })
                        }
                }
            }
            HStack {
                // Para testar o add.
                Button("Create items") {
                    do {
                        try viewModel.addItem(timeStamp: Date())
                        try viewModel.addSecondItem(name: "teste")
                    } catch {
                        showError = true
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
        // Carrega os dados já salvos no banco.
        .onAppear() {
            do {
                try viewModel.load()
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
        // Alerta para caso de erros.
        .alert("Error", isPresented: $showError) {
            Button("Confirm", role: .confirm) {
                dismiss()
            }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    // Mesma configuração no .app fazemos aqui, para que o preview funcione.
    let container = try! ModelContainer(
        for: Item.self, SecondItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    let viewModel = HomeViewModel(
        itemRepository: GenericRepository<Item>(modelContext: context),
        secondItemRepository: GenericRepository<SecondItem>(modelContext: context)
    )
    ContentView(viewModel: viewModel)
        .modelContainer(container)
}
