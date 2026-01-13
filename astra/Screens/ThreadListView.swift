//
//  ThreadListView.swift
//  astra
//
//  Created by Xil on 2026/01/14.
//

import SwiftUI


struct ThreadListView: View {

    let animeId: Int

    @EnvironmentObject var authStore: AuthStore
    @Environment(\.supabase) private var supabase

    @StateObject private var vm: ThreadViewModel
    @State private var showCreate = false

    init(animeId: Int) {
        self.animeId = animeId
        _vm = StateObject(wrappedValue: ThreadViewModel(animeId: animeId))
    }

    var body: some View {
        ZStack {
            List(vm.threads) { thread in
                NavigationLink {
                    ChatView(
                        thread: thread,
                        userId: authStore.userId!,
                        supabase: supabase
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(thread.title)
                            .font(.headline)

                        Text(thread.profile.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.plain)

            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Threads")
        .task {
            await vm.load()
        }
        .sheet(isPresented: $showCreate) {
            ThreadCreateView(vm: vm, accessToken: authStore.accessToken)
        }
    }
}



struct ThreadCreateView: View {

    @ObservedObject var vm: ThreadViewModel
    let accessToken: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("スレタイトル", text: $vm.titleText)
                    .textFieldStyle(.roundedBorder)

                Button("作成") {
                    Task {
                        await vm.create(accessToken: accessToken)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("スレ作成")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
