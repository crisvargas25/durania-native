import SwiftUI

struct ScanView: View {
    @StateObject private var viewModel = BovineScanViewModel()
    @State private var showQRScanner = false

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
                    
                    // NFC (luego le metemos funcionalidad)
                    scanButton(
                        title: "Escanear con NFC",
                        subtitle: "Identificación inmediata",
                        icon: "wave.3.right",
                        color: AppColors.tealGreen
                    ) {
                        viewModel.startNFCScan()
                    }

                    scanButton(
                        title: "Escanear código QR",
                        subtitle: "Abre cámara y detecta arete",
                        icon: "qrcode.viewfinder",
                        color: AppColors.forestGreen
                    ) {
                        viewModel.clearError()
                        showQRScanner = true
                    }
                    
                    // AR → NavigationLink
                    NavigationLink {
                        ARScanView()
                    } label: {
                        scanButtonLabel(
                            title: "Escanear con Cámara (AR)",
                            subtitle: "Visualiza datos en tiempo real",
                            icon: "camera.viewfinder",
                            color: AppColors.forestGreen
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 20)

                if viewModel.isScanningNFC {
                    Text("Escaneando NFC...")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                if let message = viewModel.errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
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
            .sheet(isPresented: $showQRScanner) {
                QRCodeScannerView(
                    onCodeScanned: { value in
                        showQRScanner = false
                        viewModel.handleScan(rawValue: value, source: .qr)
                    },
                    onFailure: { message in
                        showQRScanner = false
                        viewModel.errorMessage = message
                    }
                )
            }
            .navigationDestination(item: $viewModel.selectedBovine) { bovine in
                BovineDetailView(
                    bovine: bovine,
                    vaccines: viewModel.vaccines,
                    events: viewModel.events
                )
            }
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
            scanButtonLabel(
                title: title,
                subtitle: subtitle,
                icon: icon,
                color: color
            )
        }
        .buttonStyle(.plain)
    }
    
    func scanButtonLabel(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {
        
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
}

#Preview {
    ScanView()
}
