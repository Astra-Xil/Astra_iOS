//
//  ChatView.swift
//  astra
//
//  Created by Xil on 2026/01/05.
//

import SwiftUI
import Combine
@MainActor
final class ChatViewModel: ObservableObject {

    @Published private(set) var messages: [ChatMessage] = []
    @Published var isLoading = false

    func load(animeId: Int) async {
        isLoading = true

        // 仮データ（あとで Supabase に差し替える）
        messages = [
            ChatMessage(
                id: UUID(),
                userId: "u1",
                userName: "Alice",
                avatarURL: nil,
                text: "このアニメどう？",
                createdAt: .now.addingTimeInterval(-120)
            ),
            ChatMessage(
                id: UUID(),
                userId: "u2",
                userName: "Bob",
                avatarURL: nil,
                text: "普通に神",
                createdAt: .now.addingTimeInterval(-60)
            )
        ]

        isLoading = false
    }

    func send(text: String) {
        let new = ChatMessage(
            id: UUID(),
            userId: "me",
            userName: "You",
            avatarURL: nil,
            text: text,
            createdAt: .now
        )
        messages.append(new)
    }
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let userId: String
    let userName: String
    let avatarURL: String?
    let text: String
    let createdAt: Date
}



struct ChatView: View {

    let animeId: Int
    @StateObject private var vm = ChatViewModel()
    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 0) {

            MessageListView(messages: vm.messages)

            Divider()

            ChatInputBar(
                text: $inputText,
                onSend: {
                    vm.send(text: inputText)
                    inputText = ""
                }
            )
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: animeId) {
            await vm.load(animeId: animeId)
        }
    }
}

struct MessageRow: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Avatar
            AsyncImage(
                url: message.avatarURL.flatMap(URL.init)
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {

                // 名前 + 時刻
                HStack(spacing: 8) {
                    Text(message.userName)
                        .font(.footnote)
                        .fontWeight(.semibold)

                    Text(message.createdAt, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // メッセージ本文
                Text(message.text)
                    .font(.body)
                    .textSelection(.enabled) // Discord感
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
struct MessageListView: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(messages) { msg in
                    MessageRow(message: msg)
                }
            }
            .padding(.vertical, 8)
        }
    }
}


struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 8) {

            TextField("Message #anime", text: $text, axis: .vertical)
                .lineLimit(1...4)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                )

            Button {
                onSend()
            } label: {
                Image(systemName: "paperplane.fill")
            }
            .disabled(text.isEmpty)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}
