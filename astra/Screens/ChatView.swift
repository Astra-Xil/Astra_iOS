import SwiftUI
import Supabase

struct ChatView: View {

    @StateObject private var messagesVM: ChatViewModel
    @StateObject private var presenceVM: ChatPresenceViewModel

    @EnvironmentObject var authStore: AuthStore

    init(
        animeId: Int,
        userId: UUID,
        supabase: SupabaseClient
    ) {
        _messagesVM = StateObject(
            wrappedValue: ChatViewModel(
                animeId: animeId,
                userId: userId,
                supabase: supabase
            )
        )

        _presenceVM = StateObject(
            wrappedValue: ChatPresenceViewModel(
                animeId: animeId,
                userId: userId,
                supabase: supabase
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            // ===== オンライン人数 =====
            HStack(spacing: 6) {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)

                Text("\(presenceVM.onlineCount) 人がオンライン")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 6)

            Divider()

            // ===== メッセージ一覧 =====
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messagesVM.messages, id: \.id) { msg in
                            ChatBubble(
                                message: msg,
                                isMe: msg.userId == messagesVM.currentUserId
                            )
                            .id(msg.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messagesVM.messages.count) { _ in
                    if let last = messagesVM.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // ===== 入力欄 =====
            HStack(spacing: 8) {
                TextField("メッセージを入力", text: $messagesVM.text)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task {
                        await messagesVM.send(
                            accessToken: authStore.accessToken
                        )
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(messagesVM.text.isEmpty ? .gray : .blue)
                        .clipShape(Circle())
                }
                .disabled(messagesVM.text.isEmpty)
            }
            .padding()
        }
        .navigationTitle("チャット")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await messagesVM.loadInitialMessages(
                accessToken: authStore.accessToken
            )
            await messagesVM.onAppear()
            await presenceVM.start()
        }
        .onDisappear {
            messagesVM.onDisappear()
            Task {
                await presenceVM.stop()
            }
        }
    }
}

struct ChatBubble: View {

    let message: ChatMessage
    let isMe: Bool

    var body: some View {
        HStack {
            if isMe { Spacer() }

            VStack(alignment: .leading, spacing: 4) {
                Text(message.profile?.name ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(message.content)
                    .padding(10)
                    .background(isMe ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isMe ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if !isMe { Spacer() }
        }
    }
}
