import SwiftUI
import MapKit

struct MapView: View {
    
    let cows: [CowLocation]
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 24.0277,
                longitude: -104.6532
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.02,
                longitudeDelta: 0.02
            )
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(cows) { cow in
                Annotation(cow.name, coordinate: cow.coordinate) {
                    CowPin(cow: cow)
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .cornerRadius(16)
    }
}
