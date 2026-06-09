import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    
    enum Role {
        case user
        case ai
    }
    
    struct Message: Identifiable, Equatable {
        let id = UUID()
        let role: Role
        let text: String
    }
    
    let model = GenerativeModel(name: "gemini-2.5-flash", apiKey: APIKey.default)
    
    @State private var textInput = ""
    @State private var messages: [Message] = [
        Message(role: .ai, text: "Hello! How can I help you today?")
    ]
    @State private var isLoading = false
    
    func sendMessage() {
        let trimmed = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else { return }
        
        let userMessage = Message(role: .user, text: trimmed)
        messages.append(userMessage)
        textInput = ""
        isLoading = true
        
        Task {
            do {
                let response = try await model.generateContent(trimmed)
                if let text = response.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    messages.append(Message(role: .ai, text: text))
                } else {
                    messages.append(Message(role: .ai, text: "Sorry, I could not process that.\nPlease try again."))
                }
            } catch {
                messages.append(Message(role: .ai, text: "Something went wrong!\n\(error.localizedDescription)"))
            }
            isLoading = false
        }
    }
    
    @ViewBuilder
    private func bubble(for message: Message) -> some View {
        let isUser = message.role == .user
        HStack {
            if isUser { Spacer(minLength: 40) }
            Text(message.text)
                .padding(12)
                .foregroundColor(isUser ? .white : .primary)
                .background(isUser ? Color.accentColor : Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
            if !isUser { Spacer(minLength: 40) }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(.tint)
                Text("Gemini Chat")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(messages) { message in
                            bubble(for: message)
                                .id(message.id)
                        }
                        if isLoading {
                            HStack {
                                ProgressView()
                                Text("Thinking...")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                        }
                    }
                    .onChange(of: messages) { _ in
                        if let last = messages.last {
                            withAnimation(.easeOut(duration: 0.2)) {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: isLoading) { _ in
                        if let last = messages.last {
                            withAnimation(.easeOut(duration: 0.2)) {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }

            HStack(spacing: 8) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $textInput)
                        .frame(minHeight: 44, maxHeight: 120)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    if textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("Digite sua pergunta...")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                    }
                }
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(isLoading || textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.accentColor)
                        .clipShape(Circle())
                }
                .disabled(isLoading || textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    ContentView()
}
