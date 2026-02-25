import SwiftUI
import CoreLocation

extension CowLocation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct CattleLocationView: View {
    
    // 🔁 Datos simulados (mock backend)
    @State private var cows: [CowLocation] = [
        CowLocation(
            name: "Vaca #A12",
            latitude: 24.0285,
            longitude: -104.6541,
            status: .moving,
            lastUpdate: "Hace 10s"
        ),
        CowLocation(
            name: "Vaca #B07",
            latitude: 24.0262,
            longitude: -104.6518,
            status: .stopped,
            lastUpdate: "Hace 1m"
        ),
        CowLocation(
            name: "Toro #C01",
            latitude: 24.0291,
            longitude: -104.6550,
            status: .moving,
            lastUpdate: "Hace 5s"
        )
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Ubicación del ganado")
                            .font(.title2)
                            .bold()
                            .foregroundColor(AppColors.forestGreen)
                        
                        Text("Monitoreo en tiempo real")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .padding(.horizontal)
                
                // 🗺 Mapa
                MapView(cows: cows)
                    .frame(height: 320)
                    .padding(.horizontal)
                
                // 🐄 Lista
                VStack(alignment: .leading, spacing: 12) {
                    Text("Animales activos")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(cows) { cow in
                                CowCard(cow: cow)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
    }
}
