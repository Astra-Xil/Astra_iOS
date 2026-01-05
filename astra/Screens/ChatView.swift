//
//  ChatView.swift
//  astra
//
//  Created by Xil on 2026/01/05.
//

import SwiftUI
import Combine
import SwiftUI

struct ChatView: View {

    let animeId: Int

    @StateObject private var vm = ChatPostViewModel()
    @EnvironmentObject var authStore: AuthStore
    var body: some View {
        VStack(spacing: 12) {

            TextField("メッセージを入力", text: $vm.message, axis: .vertical)
                .lineLimit(1...4)
                .textFieldStyle(.roundedBorder)
                .disabled(vm.isSubmitting)

            Button {
                Task {
                    await authStore.refreshSession()
                    let success = await vm.submit(
                        animeId: animeId,
                        accessToken: authStore.accessToken
                    )
                    if success {
                        vm.message = ""
                    }
                }
            } label: {
                if vm.isSubmitting {
                    ProgressView()
                } else {
                    Text("送信")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isSubmitting || vm.message.isEmpty)

            if let error = vm.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }
}
