import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab {
                HomeView()
            } label: {
                Label("ホーム", systemImage: "house")
            }

            Tab {
                NotificationView()
            } label: {
                Label("通知", systemImage: "bell")
            }

            Tab {
                MyPageView()
            } label: {
                Label("マイページ", systemImage: "person")
            }

            // 🔍 検索（特別枠）
            Tab(role: .search) {
                AnimeSearchView()
            }
        }
    }
}
