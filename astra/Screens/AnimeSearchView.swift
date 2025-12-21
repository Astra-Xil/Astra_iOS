//
//  AnimeSearchView.swift
//  astra
//
//  Created by Xil on 2025/12/22.
//

import SwiftUI

struct AnimeSearchView: View {

  @StateObject private var vm = AnimeSearchViewModel()
  @State private var query = ""

  var body: some View {
    VStack {
      TextField("検索", text: $query)
        .textFieldStyle(.roundedBorder)
        .padding()

      if vm.isLoading {
        ProgressView()
      }

      List(vm.result) { item in
        Text(item.title)
      }
    }
    .onSubmit(of: .text) {
      Task {
        await vm.loadAnime(q: query)
      }
    }
  }
}
