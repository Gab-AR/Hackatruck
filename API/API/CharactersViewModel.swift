//
//  CharactersViewModel.swift
//  API
//
//  Created by Turma02 on 03/06/26.
//

import Foundation
import Combine

@MainActor
final class CharactersViewModel: ObservableObject {
    @Published var personagens: [HaPo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = Service()
    private var cancellables = Set<AnyCancellable>()

    func fetch(house: String = "gryffindor") {
        guard let url = URL(string: "https://hp-api.onrender.com/api/characters/house/\(house)") else {
            self.errorMessage = "URL inválida."
            return
        }

        isLoading = true
        errorMessage = nil

        service.fetchHaPo(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] personagens in
                self?.personagens = personagens
            }
            .store(in: &cancellables)
    }
}
