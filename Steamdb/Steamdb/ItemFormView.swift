import SwiftUI

struct ItemFormView: View {
    let title: String
    let initial: UFPIItem?

    // Callbacks (um dos dois deve ser fornecido)
    let onCreate: ((UFPIItemCreate) async -> Void)?
    let onUpdate: ((UFPIItemUpdate) async -> Void)?

    @Environment(\.dismiss) private var dismiss

    // Campos do formulário (usando String para facilitar teclado numérico)
    @State private var nome: String = ""
    @State private var anoLancamentoText: String = ""
    @State private var numeroVendasText: String = ""
    @State private var urlCapa: String = ""

    @State private var localError: String?

    init(title: String,
         initial: UFPIItem?,
         onCreate: ((UFPIItemCreate) async -> Void)?,
         onUpdate: ((UFPIItemUpdate) async -> Void)?) {
        self.title = title
        self.initial = initial
        self.onCreate = onCreate
        self.onUpdate = onUpdate

        // _State não pode ser setado aqui diretamente; será configurado em .onAppear
    }

    var body: some View {
        NavigationStack {
            Form {
                if let initial {
                    Section("Identificação") {
                        LabeledContent("ID", value: initial.id)
                        LabeledContent("Rev", value: initial.rev ?? "-")
                    }
                }

                Section("Dados do Jogo") {
                    TextField("Nome", text: $nome)
                        .textInputAutocapitalization(.words)

                    TextField("Ano de lançamento", text: $anoLancamentoText)
                        .keyboardType(.numberPad)

                    TextField("Número de vendas", text: $numeroVendasText)
                        .keyboardType(.numberPad)

                    TextField("URL da capa", text: $urlCapa)
                        .keyboardType(.URL)

                    if let url = URL(string: urlCapa), !urlCapa.isEmpty {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 120)
                                    .cornerRadius(8)
                            case .failure:
                                Text("Não foi possível carregar a imagem.")
                                    .foregroundStyle(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }

                if let localError {
                    Section {
                        Text(localError)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        Task { await submit() }
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .onAppear {
                if let i = initial {
                    nome = i.nome
                    anoLancamentoText = String(i.anoLancamento)
                    numeroVendasText = String(i.numeroVendas)
                    urlCapa = i.urlCapa
                }
            }
        }
    }

    private func submit() async {
        localError = nil

        guard !nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            localError = "Informe o nome."
            return
        }
        guard let ano = Int(anoLancamentoText) else {
            localError = "Ano de lançamento inválido."
            return
        }
        guard let vendas = Int(numeroVendasText) else {
            localError = "Número de vendas inválido."
            return
        }
        guard !urlCapa.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            localError = "Informe a URL da capa."
            return
        }

        if let initial, let onUpdate {
            // Atualização
            guard let rev = initial.rev else {
                localError = "Rev não encontrado para este item."
                return
            }
            let payload = UFPIItemUpdate(
                id: initial.id,
                rev: rev,
                nome: nome,
                anoLancamento: ano,
                numeroVendas: vendas,
                urlCapa: urlCapa
            )
            await onUpdate(payload)
            dismiss()
        } else if let onCreate {
            // Criação
            let payload = UFPIItemCreate(
                nome: nome,
                anoLancamento: ano,
                numeroVendas: vendas,
                urlCapa: urlCapa
            )
            await onCreate(payload)
            dismiss()
        } else {
            localError = "Ação não configurada."
        }
    }
}

#Preview {
    NavigationStack {
        ItemFormView(
            title: "Adicionar Jogo",
            initial: nil,
            onCreate: { _ in },
            onUpdate: nil
        )
    }
}
