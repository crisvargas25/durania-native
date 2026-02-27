import SwiftUI

struct ReportsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    
                    header
                    
                    ReportCard(
                        title: "Sanidad General",
                        subtitle: "Estado del hato",
                        icon: "heart.text.square.fill",
                        accent: AppColors.tealGreen
                    )
                    
                    ReportCard(
                        title: "Vacunación",
                        subtitle: "Cobertura y pendientes",
                        icon: "cross.case.fill",
                        accent: .orange
                    )
                    
                    ReportCard(
                        title: "Crecimiento",
                        subtitle: "Peso y desarrollo",
                        icon: "chart.line.uptrend.xyaxis",
                        accent: .blue
                    )
                }
                .padding()
            }
            .background(Color.white)
            .navigationTitle("Reportes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Panel Analítico")
                .font(.title2.bold())
                .foregroundColor(AppColors.forestGreen)
            
            Text("Resumen del rendimiento del rancho")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Card

struct ReportCard: View {
    
    let title: String
    let subtitle: String
    let icon: String
    let accent: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(accent)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(AppColors.forestGreen)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.6))
            }
            
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6))
                .frame(height: 160)
                .overlay(
                    VStack(spacing: 6) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title)
                            .foregroundColor(accent)
                        
                        Text("Visualización")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    ReportsView()
}
