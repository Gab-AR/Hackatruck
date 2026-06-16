//
//  ContentView.swift
//  API
//
//  Created by Turma02 on 03/06/26.
//

import SwiftUI

struct HaPo: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let alternate_names: [String]?
    let species: String
    let gender: String?
    let house: String?
    let dateOfBirth: String?
    let yearOfBirth: Int?
    let wizard: Bool?
    let ancestry: String?
    let eyeColour: String?
    let hairColour: String?
    let wand: Wand?
    let patronus: String?
    let hogwartsStudent: Bool?
    let hogwartsStaff: Bool?
    let actor: String?
    let alternate_actors: [String]?
    let alive: Bool?
    let image: String?
}

struct Wand: Codable, Hashable {
    let wood: String?
    let core: String?
    let length: Double?
}

struct ContentView: View {
    @StateObject private var viewModel = CharactersViewModel()

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            NavigationStack {
                Group {
                    if viewModel.isLoading {
                        ProgressView("Carregando...")
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Text("Erro")
                                .font(.headline)
                            Text(error)
                                .multilineTextAlignment(.center)
                            Button("Tentar novamente") {
                                viewModel.fetch()
                            }
                        }
                        .padding()
                    } else {
                        List(viewModel.personagens) { person in
                            NavigationLink(value: person) {
                                HStack(spacing: 12) {
                                    if let urlString = person.image,
                                       let url = URL(string: urlString),
                                       !urlString.isEmpty {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 56, height: 56)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 56, height: 56)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 56, height: 56)
                                                    .foregroundStyle(.secondary)
                                            @unknown default:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 56, height: 56)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 56, height: 56)
                                            .foregroundStyle(.secondary)
                                    }

                                    Text(person.name)
                                        .font(.headline)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .navigationDestination(for: HaPo.self) { person in
                            CharacterDetailView(person: person)
                        }
                    }
                }
                .navigationTitle("Personagens HP")
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct CharacterDetailView: View {
    let person: HaPo

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    if let urlString = person.image,
                       let url = URL(string: urlString),
                       !urlString.isEmpty {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 220)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 220)
                                    .frame(maxWidth: .infinity)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 220)
                                    .foregroundStyle(.secondary)
                            @unknown default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 220)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(person.name)
                            .font(.title)
                            .bold()

                        if let actor = person.actor, !actor.isEmpty {
                            LabeledContent("Ator", value: actor)
                        }
                        if let house = person.house, !house.isEmpty {
                            LabeledContent("Casa", value: house)
                        }
                        if let species = Optional(person.species), !species.isEmpty {
                            LabeledContent("Espécie", value: species)
                        }
                        if let gender = person.gender, !gender.isEmpty {
                            LabeledContent("Gênero", value: gender)
                        }
                        if let ancestry = person.ancestry, !ancestry.isEmpty {
                            LabeledContent("Ancestria", value: ancestry)
                        }
                        if let eye = person.eyeColour, !eye.isEmpty {
                            LabeledContent("Olhos", value: eye)
                        }
                        if let hair = person.hairColour, !hair.isEmpty {
                            LabeledContent("Cabelo", value: hair)
                        }
                        if let patronus = person.patronus, !patronus.isEmpty {
                            LabeledContent("Patronus", value: patronus)
                        }
                        if let dob = person.dateOfBirth, !dob.isEmpty {
                            LabeledContent("Nascimento", value: dob)
                        }
                        if let yob = person.yearOfBirth {
                            LabeledContent("Ano de Nascimento", value: String(yob))
                        }
                        if let wizard = person.wizard {
                            LabeledContent("Bruxo", value: wizard ? "Sim" : "Não")
                        }
                        if let alive = person.alive {
                            LabeledContent("Vivo", value: alive ? "Sim" : "Não")
                        }

                        if let wand = person.wand {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Varinha")
                                    .font(.headline)
                                if let wood = wand.wood, !wood.isEmpty {
                                    LabeledContent("Madeira", value: wood)
                                }
                                if let core = wand.core, !core.isEmpty {
                                    LabeledContent("Núcleo", value: core)
                                }
                                if let length = wand.length {
                                    LabeledContent("Comprimento", value: String(format: "%.1f\"", length))
                                }
                            }
                            .padding(.top, 8)
                        }

                        if let alternates = person.alternate_names, !alternates.isEmpty {
                            LabeledContent("Nomes alternativos", value: alternates.joined(separator: ", "))
                        }
                        if let altActors = person.alternate_actors, !altActors.isEmpty {
                            LabeledContent("Atores alternativos", value: altActors.joined(separator: ", "))
                        }
                        if let staff = person.hogwartsStaff {
                            LabeledContent("Staff de Hogwarts", value: staff ? "Sim" : "Não")
                        }
                        if let student = person.hogwartsStudent {
                            LabeledContent("Estudante de Hogwarts", value: student ? "Sim" : "Não")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
