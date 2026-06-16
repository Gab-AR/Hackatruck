import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UFPIViewModel(service: UFPIService())
    @State private var isPresentingAddForm = false
    @State private var editingItem: UFPIItem?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.items.isEmpty {
                    ProgressView("Carregando...")
                } else if viewModel.items.isEmpty {
                    ContentUnavailableView("Sem itens", systemImage: "tray", description: Text("Use o botão + para adicionar um novo item."))
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            ItemRowView(
                                item: item,
                                onEdit: {
                                    editingItem = item
                                },
                                onRefresh: {
                                    Task { await viewModel.reloadOne(item) }
                                }
                            )
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task { await viewModel.delete(item) }
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("SteamDB")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.load() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    Button {
                        isPresentingAddForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await viewModel.load()
            }
            .refreshable {
                await viewModel.load()
            }
            .alert("Erro", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $isPresentingAddForm) {
                ItemFormView(
                    title: "Adicionar Jogo",
                    initial: nil,
                    onCreate: { new in
                        await viewModel.add(new)
                    },
                    onUpdate: nil
                )
            }
            .sheet(item: $editingItem) { item in
                ItemFormView(
                    title: "Atualizar Jogo",
                    initial: item,
                    onCreate: nil,
                    onUpdate: { updated in
                        await viewModel.update(updated)
                    }
                )
            }
        }
    }
}

private struct ItemRowView: View {
    let item: UFPIItem
    let onEdit: () -> Void
    let onRefresh: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: item.urlCapa)) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(width: 80, height: 45)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 60)
                        .clipped()
                        .cornerRadius(6)
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.2)
                        Image(systemName: "photo")
                    }
                    .frame(width: 120, height: 60)
                    .cornerRadius(6)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(item.nome)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    Label("\(item.anoLancamento)", systemImage: "calendar")
                    Label(NumberFormatter.localizedString(from: NSNumber(value: item.numeroVendas), number: .decimal), systemImage: "cart")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Button {
                        onEdit()
                    } label: {
                        Label("", systemImage: "pencil")
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ContentView()
}
