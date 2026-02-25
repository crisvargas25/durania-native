import SwiftUI

struct ScanView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                
                // MARK: - Hero
                
                ZStack {
                    Circle()
                        .fill(AppColors.tealGreen.opacity(0.15))
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(AppColors.tealGreen)
                }
                .padding(.top, 30)
                
                VStack(spacing: 8) {
                    Text("Escaneo Inteligente")
                        .font(.title2.bold())
                        .foregroundColor(AppColors.forestGreen)
                    
                    Text("Identifica bovinos con NFC o realidad aumentada")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                // MARK: - Buttons
                
                VStack(spacing: 16) {
                    
                    scanButton(
                        title: "Escanear con NFC",
                        subtitle: "Identificación inmediata",
                        icon: "wave.3.right",
                        color: AppColors.tealGreen
                    ) {
                        print("NFC")
                    }
                    
                    scanButton(
                        title: "Escanear con Cámara (AR)",
                        subtitle: "Visualiza datos en tiempo real",
                        icon: "camera.viewfinder",
                        color: AppColors.forestGreen
                    ) {
                        print("AR")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // MARK: - Footer
                
                Text("Acerca tu iPhone al arete NFC del animal")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 12)
            }
            .padding()
            .background(Color.white)
            .navigationTitle("Escanear")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Components
    
    func scanButton(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        
        Button(action: action) {
            HStack(spacing: 14) {
                
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 64)
            .background(Color(.systemGray6))
            .cornerRadius(18)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ScanView()
}
