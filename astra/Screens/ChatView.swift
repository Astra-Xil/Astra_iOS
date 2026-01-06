import SwiftUI
import Supabase

struct ChatView: View {

    @StateObject private var vm: ChatViewModel

    init(
        animeId: Int,
        userName: String,
        supabase: SupabaseClient
    ) {
        _vm = StateObject(
            wrappedValue: ChatViewModel(
                animeId: animeId,
                userName: userName,
                supabase: supabase
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            // ===== メッセージ一覧 =====
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(vm.messages) { msg in
                            ChatBubble(
                                message: msg,
                                isMe: msg.userName == vm.currentUserName
                            )

                                .id(msg.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: vm.messages.count) { _ in
                    if let last = vm.messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // ===== 入力欄 =====
            HStack(spacing: 8) {
                TextField("メッセージを入力", text: $vm.text)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task {
                        await vm.send()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(vm.text.isEmpty ? Color.gray : Color.blue)
                        .clipShape(Circle())
                }
                .disabled(vm.text.isEmpty)
            }
            .padding()
        }
        .navigationTitle("チャット")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.onAppear()
        }
        .onDisappear {
            vm.onDisappear()
        }
    }
}
import SwiftUI

struct ChatBubble: View {

    let message: ChatMessage
    let isMe: Bool

    var body: some View {
        HStack {
            if isMe { Spacer() }

            VStack(alignment: .leading, spacing: 4) {
                Text(message.userName)
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
