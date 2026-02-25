import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.forestGreen, .tealGreen],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {

                    VStack(spacing: 10) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.lint)

                        Text("Durania")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)

                        Text("Gestión inteligente de ganado")
                            .font(.headline)
                            .foregroundColor(.lint.opacity(0.9))
                    }

                    VStack(spacing: 18) {

                        HomeButton(
                            title: "Mi Ganado",
                            icon: "hare.fill",
                            destination: AnyView(CattleListView())
                        )

                        HomeButton(
                            title: "Registros",
                            icon: "doc.text.fill",
                            destination: AnyView(RecordsView())
                        )

                        HomeButton(
                            title: "Estadísticas",
                            icon: "chart.bar.fill",
                            destination: AnyView(StatsView())
                        )
                    }
                    .padding(.top, 25)

                    Spacer()
                }
                .padding()
            }
        }
    }
}
