import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    
                    headerSection
                    
                    statsGrid
                    
                    healthChart
                    
                    quickActions
                }
                .padding()
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header
    
    var headerSection: some View {
        HStack(alignment: .center) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Buen día👋")
                    .font(.title2)
                    .bold()
                    .foregroundColor(AppColors.forestGreen)
                
                Text("Rancho El Roble · Durango")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
            
            NavigationLink {
                ProfileView()
            } label: {
                ZStack {
                    Circle()
                        .fill(AppColors.tealGreen.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.forestGreen)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Stats Grid
    
    var statsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 16
        ) {
            DashboardCard(
                title: "Bovinos",
                value: "124",
                icon: "hare.fill",
                color: AppColors.tealGreen
            )
            
            DashboardCard(
                title: "Vacunas Pendientes",
                value: "6",
                icon: "cross.case.fill",
                color: .orange
            )
            
            DashboardCard(
                title: "Observación",
                value: "3",
                icon: "eye.fill",
                color: .yellow
            )
            
            DashboardCard(
                title: "Cuarentena",
                value: "1",
                icon: "exclamationmark.triangle.fill",
                color: .red
            )
        }
    }
    
    // MARK: - Health Chart
    
    var healthChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estado Sanitario General")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.forestGreen)
            
            HStack(alignment: .bottom, spacing: 14) {
                chartBar(value: 120, color: AppColors.tealGreen, label: "Sanos")
                chartBar(value: 60, color: .orange, label: "Obs.")
                chartBar(value: 30, color: .red, label: "Cuar.")
            }
            .frame(height: 180)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
    
    func chartBar(value: CGFloat, color: Color, label: String) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(height: value)
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppColors.forestGreen.opacity(0.75))
        }
    }
    
    // MARK: - Quick Actions
    
    var quickActions: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Acciones rápidas")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.forestGreen)
            
            HStack(spacing: 14) {
                QuickActionButton(
                    title: "Escanear",
                    icon: "dot.radiowaves.left.and.right",
                    color: AppColors.tealGreen
                )
                
                QuickActionButton(
                    title: "Registrar vacuna",
                    icon: "cross.case.fill",
                    color: .orange
                )
            }
        }
    }
}

#Preview {
    HomeView()
}
