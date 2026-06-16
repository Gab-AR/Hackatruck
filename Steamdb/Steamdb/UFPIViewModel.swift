import Foundation
import SwiftUI
import Combine

@MainActor
final class UFPIViewModel: ObservableObject {
    @Published var items: [UFPIItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: UFPIService

    init(service: UFPIService) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            items = try await service.fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func add(_ new: UFPIItemCreate) async {
        do {
            _ = try await service.create(new)
            await load() // recarrega para refletir _id/_rev
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func update(_ updated: UFPIItemUpdate) async {
        do {
            let ack = try await service.update(updated)
            if let newRev = ack?.rev, let idx = items.firstIndex(where: { $0.id == updated.id }) {
                items[idx].rev = newRev
                items[idx].nome = updated.nome
                items[idx].anoLancamento = updated.anoLancamento
                items[idx].numeroVendas = updated.numeroVendas
                items[idx].urlCapa = updated.urlCapa
            } else {
                await load()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(_ item: UFPIItem) async {
        do {
            guard let rev = item.rev else {
                errorMessage = "Rev não encontrado para este item."
                return
            }
            _ = try await service.delete(id: item.id, rev: rev)
            items.removeAll { $0.id == item.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Recarrega apenas um item (se o endpoint suportar; aqui, recarrega tudo e substitui o item)
    func reloadOne(_ item: UFPIItem) async {
        do {
            let newList = try await service.fetchItems()
            if let updated = newList.first(where: { $0.id == item.id }),
               let idx = items.firstIndex(where: { $0.id == item.id }) {
                items[idx] = updated
            } else {
                items = newList
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
