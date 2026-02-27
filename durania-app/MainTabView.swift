import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
            
            CattleListView()
                .tabItem {
                    Label("Bovinos", systemImage: "list.bullet.rectangle")
                }
            
            ScanView()
                .tabItem {
                    Label("Escanear", systemImage: "dot.radiowaves.left.and.right")
                }
            
            ReportsView()
                .tabItem {
                    Label("Reportes", systemImage: "chart.bar.xaxis")
                }
            
            CattleLocationView()
                .tabItem {
                    Label("Ubicación", systemImage: "map.fill")
                }
        }
        .tint(.green)
    }
}

#Preview {
    MainTabView()
}
