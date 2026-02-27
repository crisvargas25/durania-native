import Foundation
import CoreLocation

struct CowLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let status: CowStatus
    let lastUpdate: String
}

enum CowStatus: String {
    case moving = "En movimiento"
    case stopped = "Detenida"
}
