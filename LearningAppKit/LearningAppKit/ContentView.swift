//
//  ContentView.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: HomeViewModel
    
    // Error handling
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            HStack {
                List(viewModel.items) { item in
                    Text(item.timestamp.description)
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
        .onAppear() {
            do {
                try viewModel.load()
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
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
